lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "optimus_primer/version"

Gem::Specification.new do |spec|
  spec.name          = "optimus_primer"
  spec.version       = OptimusPrimer::VERSION
  spec.authors       = ["M Dwyer"]
  spec.email         = ["mdwyer@mdwyer.io"]

  spec.summary       = %q{Switching for Nvidia Optimus setups}
  spec.description   = %q{Gem to allow switching between intel and nvidia in Optimus setups}
  spec.homepage      = "https://mdwyer.io"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/m-dwyer"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|config)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = ["optimus-primer"]
  spec.require_paths = ["lib"]

  # spec.add_runtime_dependency "config"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "ruby-debug-ide", "~> 0.7.0"
  spec.add_development_dependency "debase", "= 0.2.3.beta5"
end
