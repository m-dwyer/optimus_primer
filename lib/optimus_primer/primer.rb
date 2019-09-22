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
        set_xorg_config('intel')
        enable_power_management
      when 'nvidia'
        blacklist_nvidia(false)
        set_xorg_config('nvidia')
        enable_power_management(false)
      end
    end

    private

    def blacklist_nvidia(enable = true)
      # create/remove blacklist file
      FeatureManager.toggle_feature(:nvidia, :blacklisting, enable, @config)
    end

    def set_xorg_config(mode)
      case mode
      when :intel
        FeatureManager.toggle_feature(:intel, :xorg, true, @config)
        FeatureManager.toggle_feature(:nvidia, :xorg, false, @config)
      when :nvidia
        FeatureManager.toggle_feature(:intel, :xorg, true, @config)
        FeatureManager.toggle_feature(:nvidia, :xorg, true, @config)
      end
    end

    def set_power_management(enable = true)
      FeatureManager.toggle_feature(:nvidia, :power_management, enable, @config)
    end
  end
end
