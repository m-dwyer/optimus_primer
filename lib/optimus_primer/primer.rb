# frozen_string_literal: true
require_relative 'pci'

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
        enable_power_management
      when 'nvidia'
        blacklist_nvidia(false)
        enable_power_management(false)
      end
    end

    private

    def blacklist_nvidia(enable = true)
      # create/remove blacklist file
      if enable
        $stdout.puts "Copying blacklist conf #{@config[:nvidia][:blacklist_conf]} to #{@config[:nvidia][:blacklist_file]}"
        File.copy_stream(@config[:nvidia][:blacklist_conf], @config[:nvidia][:blacklist_file])
      else
        $stdout.puts "Removing blacklist file #{@config[:nvidia][:blacklist_file]}"
        File.delete(@config[:nvidia][:blacklist_file])
      end

      true
    end

    def enable_power_management(enable = true)
      if enable
        nvidia_card = @nvidia_displays[0]
        $stdout.puts "Enabling nvidia power management on #{nvidia_card[:pci_domain_bdf]}"
        #@pci.write_pci_path(nvidia_card[:pci_domain_bdf], Pci::POWER_PATH, 'auto')
      else
        $stdout.puts "Disabling nvidia power management"
        #@pci.write_pci_path(nvidia_card[:pci_domain_bdf], Pci::POWER_PATH, 'on')
      end
    end
  end
end
