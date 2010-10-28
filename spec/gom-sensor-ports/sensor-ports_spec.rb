require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Gom::SensorPorts" do

  before :each do
    $gom = Gom::Remote.connection = Object.new
    (Gom::Remote::Connection.stub! :new).and_return $gom
    ($gom.stub! :read).with('/gom/sensor-ports.json').and_return(<<-JSON)
      {
        "node": {
          "uri": "/gom-sensor-ports",
          "entries": [
            { "attribute": {
              "name": "status",
              "node": "/gom-sensor-ports",
              "value": "<void>", "type": "string"
            } }
          ]
        }
      }
    JSON
  end

  describe "#status" do
    it "should dump status" do 
      station = Gom::SensorPorts.new '/gom/sensor-ports'
      station.status.should be
    end
  end
end
