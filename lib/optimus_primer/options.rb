module OptimusPrimer
  class Options < OpenStruct
    def load_options(config)
      constructed_options = recursive_convert(config)
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