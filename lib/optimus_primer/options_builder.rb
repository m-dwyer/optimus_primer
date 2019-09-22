require_relative 'options/generic_options'
require_relative 'options/nvidia_udev_options'
require_relative 'options/nvidia_acpi_options'
require_relative 'options/nvidia_gpu_remove_options'

module OptimusPrimer
  class OptionsBuilder
    FEATURE_OPTIONS_MAP = {
      :power_management => NvidiaUDevOptions,
      :acpi => NvidiaAcpiOptions,
      :pci_removal => NvidiaGpuRemoveOptions
    }.freeze
    PASSTHROUGH_OPTIONS = GenericOptions

    class << self
      def build_options(feature_name, config, contents)
        klass = FEATURE_OPTIONS_MAP.fetch(feature_name.to_sym, PASSTHROUGH_OPTIONS)
        klass.build(config, contents)
      end
    end
  end
end