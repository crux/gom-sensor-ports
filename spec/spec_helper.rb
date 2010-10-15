#$:.unshift(File.dirname(__FILE__))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'gom-sensor-ports'
require 'spec'
require 'spec/autorun'
require 'fakeweb'

Spec::Runner.configure do |config|
  config.before :each do
    FakeWeb.allow_net_connect = false
  end
end
