require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "gom-sensor-ports"
    gem.summary = %Q{
      gateway for barebone TCP/UCP reporting sensors to GOM/HTTP protocoll
    }
    gem.description = %Q{
      This gems implements a gateway server to allow barebone basic sensor
      components to report state change updates as simple protocol free udates
      over TCP/UDP ports without the 'overhead' of the HTTP protocoll. For
      example, a power sensor might just broadcast a four byte floating point
      binary number once every second to an UCP port
    }
    gem.email = "dirk.luesebrink@gmail.com"
    gem.homepage = "http://github.com/crux/gom-sensor-ports"
    gem.authors = ["art+com AG/dirk luesebrink"]

    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "fakeweb"

    gem.add_runtime_dependency "applix"
    gem.add_runtime_dependency "gom-script"
    gem.add_runtime_dependency "gom-core"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

#require 'spec/rake/spectask'
#Spec::Rake::SpecTask.new(:spec) do |spec|
#  spec.libs << 'lib' << 'spec'
#  spec.spec_files = FileList['spec/**/*_spec.rb']
#end
#Spec::Rake::SpecTask.new(:rcov) do |spec|
#  spec.libs << 'lib' << 'spec'
#  spec.pattern = 'spec/**/*_spec.rb'
#  spec.rcov = true
#end
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:rcov) do |t|
  t.rcov_opts =  %q[--exclude "spec"]
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "gom-sensor-ports #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
