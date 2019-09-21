require 'yaml'
require 'pathname'
require 'ostruct'
require_relative 'options'

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
end
