# frozen_string_literal: true
require_relative 'feature_manager'

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
        set_xorg_config(:intel)
        set_power_management(true)
        set_acpi(true)
        set_pci_removal(true)
      when 'nvidia'
        blacklist_nvidia(false)
        set_xorg_config(:nvidia)
        set_power_management(false)
        set_acpi(false)
        set_pci_removal(false)
      end
    end

    private

    def blacklist_nvidia(enable = true)
      # create/remove blacklist file
      FeatureManager.toggle_feature(:blacklisting, @config, enable)
    end

    def set_xorg_config(mode)
      case mode
      when :intel
        FeatureManager.toggle_feature(:intel_hybrid_xorg, @config, false)
        FeatureManager.toggle_feature(:intel_xorg, @config, true)
        FeatureManager.toggle_feature(:nvidia_xorg, @config, false)
      when :nvidia
        FeatureManager.toggle_feature(:intel_xorg, @config, false)
        FeatureManager.toggle_feature(:intel_hybrid_xorg, @config, true)
        FeatureManager.toggle_feature(:nvidia_xorg, @config, true)
      end
    end

    def set_power_management(enable = true)
      FeatureManager.toggle_feature(:power_management, @config, enable)
    end

    def set_acpi(enable = true)
      FeatureManager.toggle_feature(:acpi, @config, enable)
    end

    def set_pci_removal(enable = true)
      FeatureManager.toggle_feature(:pci_removal, @config, enable)
    end
  end
end
