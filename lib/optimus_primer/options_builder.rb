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

    class << self
      def build_options(klass, config, contents)
        options = klass.build(config, contents)
        options.render
      end
    end
  end
end