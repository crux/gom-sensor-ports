# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'gom/sensor_ports/version'

Gem::Specification.new do |s|
  s.name        = 'gom-sensor-ports'
  s.version     = Gom::SensorPorts::VERSION
  s.authors     = ['art+com/dirk luesebrink']
  s.email       = ['dirk.luesebrink@artcom.de']
  s.homepage    = 'http://github.com/crux/gom-sensor-ports'
  s.summary     = %q{
    gateway for barebone TCP/UCP reporting sensors to GOM/HTTP protocol
  }
  s.description = %q{ 
    Implements a gateway server to allow barebone basic sensor components to
    report state change updates as simple via TCP/UDP ports without the
    'overhead' of the HTTP protocol. A power sensor for example might just
    broadcast a four byte floating point binary number once every second to an
    UDP port or an arduino board sends a UDP datagram whenever a button is
    pushed. You get the idea, this is how to bring embedded devices into the
    world of HTTP and Javascript...
  }

  s.add_dependency 'daemons'
  s.add_dependency 'gom-core', '~>0.2.2'
  s.add_dependency 'gom-script', '~>0.2.2'

  # development section
  #
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-mocks'
  s.add_development_dependency 'fakeweb'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'growl'
  if RUBY_PLATFORM.match /java/i
    s.add_development_dependency 'ruby-debug'
  else
    s.add_development_dependency 'debugger'
  end

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map do |f| 
    File.basename(f)
  end
  s.require_paths = ["lib"]
end
