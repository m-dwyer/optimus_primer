require 'erb'

module OptimusPrimer
  module OptionsTemplate
    def self.included klass
      klass.class_eval do
        class << self
          def build(all_config, contents)
            self.new(all_config, contents)
          end
        end

        def initialize(all_config, contents)
          @all_config = all_config
          @contents = contents
        end

        def build_options
        end

        def render
          build_options
          renderer = ERB.new(@contents)
          renderer.result(binding)
        end
      end
    end
  end
end