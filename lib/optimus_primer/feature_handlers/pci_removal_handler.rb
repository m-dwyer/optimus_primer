require_relative 'handler'
require_relative '../options/nvidia_gpu_remove_options'

module OptimusPrimer
  class PciRemovalHandler
    FEATURE_PATH = %i[nvidia pci_removal]

    include Handler

    def options_class
      NvidiaGpuRemoveOptions
    end
  end
end