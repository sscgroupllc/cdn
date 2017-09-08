# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cdn/version'

Gem::Specification.new do |s|
  s.name = 'cdn'
  s.version = CDN::VERSION
  s.authors = ['Russ Smith (russ@bashme.org)']
  s.email = 'russ@bashme.org'
  s.homepage = 'http://github.com/sscgroup/cdn'
  s.summary = 'CDN support for various providers.'
  s.description = 'CDN support for various providers.'

  s.files         = `git ls-files -z`.split("\x0")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
  s.add_dependency('aws_cf_signer', '~> 0.1')
  s.add_dependency('erubis')
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', '~> 3.5')
  s.add_development_dependency('yard')
  s.add_development_dependency('timecop')
  s.add_development_dependency "bundler", "~> 1.7"
  s.add_development_dependency "geminabox"
end
