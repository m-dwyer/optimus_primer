require 'yaml'
require 'pathname'
require 'ostruct'

module OptimusPrimer
  class Config
    DEFAULT_CONFIG_ROOT = '/etc/optimus_primer'.freeze
    CONFIG_FILE = 'primer.conf'

    class << self
      def load
        load_file(env_path(CONFIG_FILE))
      end

      def load_file(file)
        load_config(YAML.load(File.read(file)))
      end

      def load_config(config)
        options = Options.new
        options.source = config
        options.load_options
      end

      def current_mode_path
        File.join(config_root, 'current_mode')
      end

      def config_root
        prod? ? DEFAULT_CONFIG_ROOT : "config"
      end

      def env
        ENV["PRIMER_DEV"].nil? ? :prod : :dev
      end
      
      def env_path(path, no_environment = false)
        File.join(config_root, (no_environment or env == :prod) ? "" : env.to_s, path)
      end

      private

      def dev?
        env == :dev
      end

      def prod?
        env == :prod
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
        when String
          v = convert_path(v) if is_path? k.to_s
        end
        s.send("#{k}=".to_sym, v)
      end

      s
    end

    def is_path?(key)
      key.end_with? 'file' or key.end_with? 'conf'
    end

    def convert_path(path)
      return path if Pathname.new(path).absolute?

      return Config.env_path(path) if File.exists? Config.env_path(path)
      return Config.env_path(path, true) if File.exists? Config.env_path(path, true)
      return Config.env_path(path)
    end
  end
end
