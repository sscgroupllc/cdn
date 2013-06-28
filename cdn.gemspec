# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'cdn/version'

Gem::Specification.new do |s|
  s.name = 'cdn'
  s.version = CDN::VERSION
  s.authors = ['Russ Smith (russ@bashme.org)']
  s.email = 'russ@bashme.org'
  s.homepage = 'http://github.com/sscgroup/cdn'
  s.summary = 'CDN support for various providers.'
  s.description = 'CDN support for various providers.'
  s.rubyforge_project = 'cdn'
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
  s.add_dependency('activesupport', '>= 2.3.10')
  s.add_dependency('aws_cf_signer', '~> 0.1')
  s.add_dependency('erubis')
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', '~> 2.5')
  s.add_development_dependency('yard')
  s.add_development_dependency('timecop')
end
