require_relative 'handler'

module OptimusPrimer
  class AcpiHandler
    FEATURE_PATH = %i[nvidia acpi]

    include Handler
  end
end