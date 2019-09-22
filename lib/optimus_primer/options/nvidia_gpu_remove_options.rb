require_relative 'options_template'
require_relative '../pci'

module OptimusPrimer
  class NvidiaGpuRemoveOptions
    include OptionsTemplate
  
    def build_options
      pci = Pci.new
      intel_displays, nvidia_displays = pci.display_controllers
      @gpu_pci_id = nvidia_displays[0][:pci_domain_bdf]
    end
  end
end