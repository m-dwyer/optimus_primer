require_relative 'handler'

module OptimusPrimer
  class AcpiHandler
    FEATURE_PATH = %i[nvidia acpi]

    include Handler

    def handle(enable = true)
      enable ? enable_feature : disable_feature
    end

    def enable_feature
      write_acpi_call_load
      write_acpi_call_method
    end

    def disable_feature
      acpi_call_dest = convert_path(@feature_config[:acpi_call][:dest])
      acpi_call_method_dest = convert_path(@feature_config[:acpi_call_set][:dest])
      delete_file(acpi_call_dest)
      delete_file(acpi_call_method_dest)
    end

    private

    def write_acpi_call_load
      acpi_call_load_contents = File.read(convert_path(@feature_config[:acpi_call][:source]))
      acpi_call_dest = convert_path(@feature_config[:acpi_call][:dest])
      write_file(acpi_call_load_contents, acpi_call_dest)
    end

    def write_acpi_call_method
      acpi_call_method_contents = File.read(convert_path(@feature_config[:acpi_call_set][:source]))
      acpi_call_method_dest = convert_path(@feature_config[:acpi_call_set][:dest])
      built_options = OptionsBuilder.build_options(NvidiaAcpiOptions, @all_config, acpi_call_method_contents)
      write_file(built_options, acpi_call_method_dest)
    end
  end
end