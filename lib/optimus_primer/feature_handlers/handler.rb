require_relative '../options_builder'
require 'fileutils'

module OptimusPrimer
  module Handler
    def self.included klass
      klass.class_eval do
        class << self
          def handle(all_config, enable = true)
            handler = self.new(all_config)
            handler.handle(enable)
          end
        end

        def initialize(all_config)
          @all_config = all_config
        end

        def handle(enable = true)
          puts "#{enable} for #{self.class}"

          @feature_config = @all_config.dig(*self.class::FEATURE_PATH)

          return if @feature_config.nil? or !@feature_config[:enabled]

          @source = convert_path(@feature_config[:source])
          @dest = convert_path(@feature_config[:dest])

          enable ? enable_feature : disable_feature
        end

        private

        def enable_feature
          built_options = OptionsBuilder.build_options(options_class, @all_config, File.read(@source))
          write_file(built_options, @dest)
        end

        def disable_feature
          delete_file(@dest)
        end

        def options_class
          GenericOptions
        end

        def convert_path(path)
          return path if Pathname.new(path).absolute?
    
          return Config.env_path(path) if File.exists? Config.env_path(path)
          return Config.env_path(path, true) if File.exists? Config.env_path(path, true)
          return Config.env_path(path)
        end

        def write_file(contents, path)
          FileUtils.mkdir_p(File.dirname(path))
          File.write(path, contents)
        end

        def delete_file(path)
          File.delete(path) if File.exists? path
        end
      end
    end
  end

  class DefaultHandler
    include Handler
  end
end