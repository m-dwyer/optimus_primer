require_relative 'options_builder'
require_relative 'config'
require 'fileutils'

module OptimusPrimer
  class FeatureManager
    class << self
      def toggle_feature(scope, feature_name, enable, all_config)
        feature_config = all_config.dig(scope, feature_name)
        return unless feature_config[:enabled]

        if enable
          enable_feature(feature_name, feature_config, all_config)
        else
          disable_feature(feature_name, feature_config)
        end
      end

      private

      def enable_feature(feature_name, feature_config, all_config)
        return unless feature_config[:source] and feature_config[:dest]

        source = convert_path(feature_config[:source])
        dest = convert_path(feature_config[:dest])

        built_options = OptionsBuilder.build_options(feature_name, all_config, File.read(source))
        write_file(built_options.render, dest)
      end

      def disable_feature(feature_name, feature_config)
        delete_file(convert_path(feature_config[:dest]))
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