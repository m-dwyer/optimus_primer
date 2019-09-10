require 'yaml'

module OptimusPrimer
  class Config
    class << self
      def load(file)
        YAML.load(File.read(file))
      end
    end
  end
end
