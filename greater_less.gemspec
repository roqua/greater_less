# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "greater_less"
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Samuel Esposito", "Jorn van de Beek"]
  s.date = Date.today.to_s
  s.description = "The GreaterLess Gem allows for making comparisons between floats and half-open intervals and apply simple arithmetics to the intervals preserving their mathematical meaning."
  s.email = "support@roqua.nl"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    ".rspec",
    ".travis.yml",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "CHANGELOG.md",
    "Rakefile",
    "greater_less.gemspec",
    "lib/greater_less.rb",
    "lib/greater_less/string_extension.rb",
    "spec/greater_less_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/roqua/greater_less"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.summary = "Gem for handling floating point half-open intervals"

  s.add_development_dependency 'rake', '~> 0'
  s.add_development_dependency 'rdoc', '~> 0'
  s.add_development_dependency 'bundler', '~> 0'
  s.add_development_dependency 'rspec', '~> 3'
  s.add_development_dependency 'shoulda-matchers', '~> 0'
  s.add_development_dependency 'simplecov', '~> 0'
end

