# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'uniq_logger/version'

Gem::Specification.new do |spec|
  spec.name          = "uniq_logger"
  spec.version       = UniqLogger::VERSION
  spec.authors       = ["Marco Metz"]
  spec.email         = ["marco.metz@gmail.com"]
  spec.summary       = %q{checks for existing Logentries and adds new LogEntries}
  spec.description   = %q{Adds Entries to an Logfile, only if not already exist. Logfile can be on an ftp account}
  spec.homepage      = "https://github.com/ikuseiGmbH/uniq_logger"
  spec.license       = "GNU GENERAL PUBLIC LICENSE"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
