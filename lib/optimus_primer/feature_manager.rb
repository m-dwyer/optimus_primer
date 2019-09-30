#require_relative 'options_builder'
require_relative 'config'
require_relative 'feature_handlers/generic_handlers'
require_relative 'feature_handlers/handler'
require_relative 'feature_handlers/acpi_handler'
require_relative 'feature_handlers/blacklisting_handler'
require_relative 'feature_handlers/pci_removal_handler'
require_relative 'feature_handlers/power_management_handler'

module OptimusPrimer
  class FeatureManager
    # TODO: refactor
    FEATURE_HANDLER_MAP = {
      :acpi => AcpiHandler,
      :blacklisting => BlacklistingHandler,
      :pci_removal => PciRemovalHandler,
      :power_management => PowerManagementHandler,
      :intel_xorg => IntelXOrgHandler,
      :intel_hybrid_xorg => IntelHybridXOrgHandler,
      :nvidia_xorg => NvidiaXOrgHandler
    }.freeze

    class << self
      def toggle_feature(feature_name, all_config, enable)
        klass = FEATURE_HANDLER_MAP.fetch(feature_name.to_sym)
        return if klass.nil?

        feature_config = all_config.dig(*klass::FEATURE_PATH)
        return unless feature_config[:enabled]

        klass.new(all_config).handle(enable)
      end
    end
  end
end