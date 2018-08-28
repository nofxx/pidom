lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pidom/version'

Gem::Specification.new do |gem|
  gem.name          = 'pidom-control'
  gem.version       = Pidom::VERSION
  gem.authors       = ['Andrew Nordman', 'Marcos Piccinini']
  gem.email         = ['pidr@pidr.com']
  gem.description   = 'PID Control Library'
  gem.summary       = 'Temperature/motion controller based on the PID PonM algorithm'
  gem.homepage      = 'https://github.com/nofxx/pidom'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rspec'
end
