# frozen_string_literal: true
require 'fileutils'
require_relative 'pci'
require_relative 'options_builder'

module OptimusPrimer
  class Error < StandardError; end

  MODES = %w[intel nvidia].freeze

  class Primer
    def initialize(config)
      @config = config
    end

    def switch(mode)
      case mode
      when 'intel'
        blacklist_nvidia
        set_xorg_config('intel')
        enable_power_management if @config[:nvidia][:power_management][:enabled]
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
        write_options(:nvidia, :blacklist_conf, @config[:nvidia][:blacklist_file]) if @config[:nvidia][:blacklist_conf]
      else
        $stdout.puts "Removing blacklist file #{@config[:nvidia][:blacklist_file]}"
        File.delete(@config[:nvidia][:blacklist_file]) if File.exists? @config[:nvidia][:blacklist_file]
      end
    end

    def enable_power_management(enable = true)
      if enable
        $stdout.puts "Enabling nvidia power management udev rule"
        write_options(:nvidia, :power_udev_conf, @config[:nvidia][:power_udev_file])
        $stdout.puts "Turning off nvidia GPU via ACPI call"
        write_options(:nvidia, :power_management, :acpi_call_conf, @config[:nvidia][:power_management][:acpi_call_file]) if @config[:nvidia][:power_management][:acpi]
        write_options(:nvidia, :power_management, :acpi_call_set_conf, @config[:nvidia][:power_management][:acpi_call_set_file]) if @config[:nvidia][:power_management][:acpi]
        write_options(:nvidia, :power_management, :pci_remove_conf, @config[:nvidia][:power_management][:pci_remove_file]) if @config[:nvidia][:power_management][:pci_remove]
      else
        $stdout.puts "Disabling nvidia power management udev rule"
        File.delete(@config[:nvidia][:power_udev_file]) if File.exists? @config[:nvidia][:power_udev_file]
        File.delete(@config[:nvidia][:power_management][:acpi_call_file]) if File.exists? @config[:nvidia][:power_management][:acpi_call_file]
        File.delete(@config[:nvidia][:power_management][:acpi_call_set_file]) if File.exists? @config[:nvidia][:power_management][:acpi_call_set_file]
        File.delete(@config[:nvidia][:power_management][:pci_remove_file]) if File.exists? @config[:nvidia][:power_management][:pci_remove_file]
      end
    end

    def set_xorg_config(mode)
      case mode
      when 'intel'
        $stdout.puts "Copying intel config #{@config[:intel][:xorg_conf]} to #{@config[:intel][:xorg_file]}"
        write_options(:intel, :xorg_conf, @config[:intel][:xorg_file]) if @config[:intel][:xorg_conf]

        $stdout.puts "Removing nvidia config #{@config[:nvidia][:xorg_file]}"
        File.delete(@config[:nvidia][:xorg_file]) if File.exists? @config[:nvidia][:xorg_file]
      when 'nvidia'
        $stdout.puts "Copying intel config #{@config[:intel][:xorg_conf]} to #{@config[:intel][:xorg_file]}"
        write_options(:intel, :xorg_conf, @config[:intel][:xorg_file]) if @config[:intel][:xorg_conf]

        $stdout.puts "Copying nvidia config #{@config[:nvidia][:xorg_conf]} to #{@config[:nvidia][:xorg_file]}"
        write_options(:nvidia, :xorg_conf, @config[:nvidia][:xorg_file]) if @config[:nvidia][:xorg_conf]
      end

      def write_current_mode(mode)
        File.write(Config::current_mode_path, mode)
      end
    end

    def write_options(*options_key, dest)
      contents = File.read(@config.dig(*options_key))
      built_options = OptionsBuilder.build_options(*options_key, @config, contents)
      write_file(built_options.render, dest)
    end

    def write_file(contents, dest_file)
      FileUtils.mkdir_p(File.dirname(dest_file))
      File.write(dest_file, contents)
    end
  end
end
