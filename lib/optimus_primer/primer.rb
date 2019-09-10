# frozen_string_literal: true
require_relative 'pci'

module OptimusPrimer
  class Error < StandardError; end

  MODES = %w[intel nvidia].freeze

  class Primer
    def initialize(config)

    end

    def switch(mode)
      @intel_displays, @nvidia_displays = displays

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

    def displays
      pci = Pci.new
      pci.display_controllers
    end

    def blacklist_nvidia(enable = true)
      # create/remove blacklist file
      true
    end

    def enable_power_management(enable = true)
      # enable/disable nvidia power management
      true
    end
  end
end
