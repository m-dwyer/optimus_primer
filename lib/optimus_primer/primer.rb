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
      when 'nvidia'
        blacklist_nvidia(false)
        set_xorg_config(:nvidia)
        set_power_management(false)
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
        FeatureManager.toggle_feature(:intel_xorg, @config, true)
        FeatureManager.toggle_feature(:nvidia_xorg, @config, false)
      when :nvidia
        FeatureManager.toggle_feature(:intel_xorg, @config, true)
        FeatureManager.toggle_feature(:nvidia_xorg, @config, true)
      end
    end

    def set_power_management(enable = true)
      FeatureManager.toggle_feature(:power_management, @config, enable)
    end
  end
end
