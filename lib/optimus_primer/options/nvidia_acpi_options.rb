require_relative 'options_template'

module OptimusPrimer
  class NvidiaAcpiOptions
    include OptionsTemplate
    
    def build_options
      @acpi_method = @all_config.dig(:nvidia, :power_management, :acpi_method)
    end
  end
end