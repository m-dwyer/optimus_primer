require_relative 'options/generic_options'
require_relative 'options/nvidia_udev_options'

module OptimusPrimer
  class OptionsBuilder
    OPTION_KEY_TEMPLATE_MAP = {
      %i(nvidia power_udev_conf) => NvidiaUDevOptions
    }.freeze
    PASSTHROUGH_OPTIONS = GenericOptions

    class << self
      def build_options(*option_key, config, contents)
        klass = OPTION_KEY_TEMPLATE_MAP.fetch(option_key, PASSTHROUGH_OPTIONS)
        klass.build(config, contents)
      end
    end
  end
end