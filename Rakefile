require 'bundler/gem_tasks'
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rake'
require 'rspec/core/rake_task'
require 'cdn/version'

desc "Push cdn-#{CDN::VERSION}"
task :push do
  gem_file = "pkg/cdn-#{CDN::VERSION}.gem"
  if File.exist?(gem_file)
    system "$(which gem) inabox --host http://gvMrmyoLUkQD6ENVJoyaCEsgy9EpUc4zorH:EAaBVh2Wd9GnMUFFiQhugjGxXxxLqHkKt3p@gems.amavalet.com" 
  else
    raise "You must run `rake build` to build version #{StanServices::VERSION} first."
  end
end

namespace :spec do
  RSpec::Core::RakeTask.new(:normal) do |t|
    t.pattern ='spec/**/*_spec.rb'
    t.rcov = false
  end
end

desc 'RSpec tests'
task spec: 'spec:normal'

task default: 'spec'
