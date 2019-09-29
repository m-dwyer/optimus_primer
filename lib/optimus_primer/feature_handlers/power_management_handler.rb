require_relative 'handler'
require_relative '../options/nvidia_udev_options'

module OptimusPrimer
  class PowerManagementHandler
    FEATURE_PATH = %i[nvidia power_management]

    include Handler

    def options_class
      NvidiaUDevOptions
    end
  end
end