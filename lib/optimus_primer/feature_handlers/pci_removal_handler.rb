require_relative 'handler'

module OptimusPrimer
  class PciRemovalHandler
    FEATURE_PATH = %i[nvidia pci_removal]

    include Handler
  end
end