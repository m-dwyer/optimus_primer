# frozen_string_literal: true
require_relative 'pci'
require 'fileutils'

module OptimusPrimer
  class Error < StandardError; end

  MODES = %w[intel nvidia].freeze

  class Primer
    def initialize(config)
      @config = config
      @pci = Pci.new
      @intel_displays, @nvidia_displays = @pci.display_controllers
    end

    def switch(mode)
      case mode
      when 'intel'
        blacklist_nvidia
        set_xorg_config('intel')
        enable_power_management
        write_current_mode('intel')
      when 'nvidia'
        blacklist_nvidia(false)
        set_xorg_config('nvidia')
        enable_power_management(false)
        write_current_mode('nvidia')
      end
    end

    private

    def blacklist_nvidia(enable = true)
      # create/remove blacklist file
      if enable
        $stdout.puts "Copying blacklist conf #{@config[:nvidia][:blacklist_conf]} to #{@config[:nvidia][:blacklist_file]}"
        copy_file(@config[:nvidia][:blacklist_conf], @config[:nvidia][:blacklist_file]) if @config[:nvidia][:blacklist_conf]
      else
        $stdout.puts "Removing blacklist file #{@config[:nvidia][:blacklist_file]}"
        File.delete(@config[:nvidia][:blacklist_file]) if File.exists? @config[:nvidia][:blacklist_file]
      end
    end

    def enable_power_management(enable = true)
      nvidia_card = @nvidia_displays[0]
      if enable
        $stdout.puts "Enabling nvidia power management on #{nvidia_card[:pci_domain_bdf]}"
        @pci.write_pci_path(nvidia_card[:pci_domain_bdf], Pci::POWER_PATH, 'auto')
        $stdout.puts "Enabling nvidia power management udev rule"
        copy_file(@config[:nvidia][:power_udev_conf], @config[:nvidia][:power_udev_file])
      else
        $stdout.puts "Disabling nvidia power management"
        @pci.write_pci_path(nvidia_card[:pci_domain_bdf], Pci::POWER_PATH, 'on')
        $stdout.puts "Disabling nvidia power management udev rule"
        File.delete(@config[:nvidia][:power_udev_file]) if File.exists? @config[:nvidia][:power_udev_file]
      end
    end

    def set_xorg_config(mode)
      case mode
      when 'intel'
        $stdout.puts "Copying intel config #{@config[:intel][:xorg_conf]} to #{@config[:intel][:xorg_file]}"
        copy_file(@config[:intel][:xorg_conf], @config[:intel][:xorg_file]) if @config[:intel][:xorg_conf]

        $stdout.puts "Removing nvidia config #{@config[:nvidia][:xorg_file]}"
        File.delete(@config[:nvidia][:xorg_file]) if File.exists? @config[:nvidia][:xorg_file]
      when 'nvidia'
        $stdout.puts "Copying intel config #{@config[:intel][:xorg_conf]} to #{@config[:intel][:xorg_file]}"
        copy_file(@config[:intel][:xorg_conf], @config[:intel][:xorg_file]) if @config[:intel][:xorg_conf]

        $stdout.puts "Copying nvidia config #{@config[:nvidia][:xorg_conf]} to #{@config[:nvidia][:xorg_file]}"
        copy_file(@config[:nvidia][:xorg_conf], @config[:nvidia][:xorg_file]) if @config[:nvidia][:xorg_conf]
      end

      def write_current_mode(mode)
        File.write(Config::current_mode_path, mode)
      end
    end

    def copy_file(src, dest)
      FileUtils.mkdir_p(File.dirname(dest))
      FileUtils.copy_file(src, dest)
    end
  end
end
