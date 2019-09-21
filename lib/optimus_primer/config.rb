require 'yaml'

module OptimusPrimer
  class Config
    class << self
      def load_file(file)
        load(YAML.load(File.read(file)))
      end

      def load(config)
        options = Options.new
        options.source = config
        options.load_options
      end
    end
  end

  class Options < OpenStruct
    attr_accessor :source

    def load_options
      constructed_options = recursive_convert(@source)
      marshal_load(constructed_options.marshal_dump)
      self
    end

    private

    def recursive_convert(hash)
      s = self.class.new

      hash.each do |k, v|
        s.new_ostruct_member(k)

        case v
        when Hash
          v = recursive_convert(v)
        when Array
          v = v.map { |e| e.is_a?(Hash) ? recursive_convert(e) : e }
        end
        s.send("#{k}=".to_sym, v)
      end

      s
    end
  end
end
