require_relative 'options/generic_options'
require_relative 'options/nvidia_udev_options'
require_relative 'options/nvidia_acpi_options'
require_relative 'options/nvidia_gpu_remove_options'

module OptimusPrimer
  class OptionsBuilder
    OPTION_KEY_TEMPLATE_MAP = {
      %i(nvidia power_udev_conf) => NvidiaUDevOptions,
      %i(nvidia power_management acpi_call_set_conf) => NvidiaAcpiOptions,
      %i(nvidia power_management pci_remove_conf) => NvidiaGpuRemoveOptions
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