# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'show_code/version'

Gem::Specification.new do |spec|
  spec.name          = "show_code"
  spec.version       = ShowCode::VERSION
  spec.authors       = ["cenxky"]
  spec.email         = ["cenxky@gmail.com"]

  spec.summary       = %q{Show a method source codes of ruby/rails in terminal.}
  spec.description   = %q{show_code provides a quick way to show ruby method source codes in terminal.}
  spec.homepage      = "https://github.com/cenxky/show_code"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 1.9.0'

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
