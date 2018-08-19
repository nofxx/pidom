lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'temper/version'

Gem::Specification.new do |gem|
  gem.name          = 'temper-control'
  gem.version       = Temper::VERSION
  gem.authors       = ['Andrew Nordman']
  gem.email         = ['cadwallion@gmail.com']
  gem.description   = 'Temperature Controller Library'
  gem.summary       = 'Temperature controller based on the PID algorithm'
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rspec'
end
