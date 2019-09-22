require_relative 'options_template'

module OptimusPrimer
  class NvidiaUDevOptions
    include OptionsTemplate
  
    def build_options
      @other_power_management = @all_config.dig(:nvidia, :power_management, :other)
      @gpu_power_management = @all_config.dig(:nvidia, :power_management, :gpu)
    end
  end
end