require_relative 'options_template'

module OptimusPrimer
  class NvidiaUDevOptions
    include OptionsTemplate
  
    def build_options
      @disable_other_devices = @all_config.dig(:nvidia, :disable_other_devices)
      @enable_gpu_power_management = @all_config.dig(:nvidia, :enable_gpu_power_management)
    end
  end
end