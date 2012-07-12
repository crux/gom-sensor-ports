#$:.unshift(File.dirname(__FILE__))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'fakeweb'
require 'gom/sensor_port'

RSpec.configure do |config|
  config.before :each do
    FakeWeb.allow_net_connect = false

    $gom = Gom::Remote.connection = Object.new
    (Gom::Remote::Connection.stub! :new).and_return $gom
  end
end
