require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Gom::SensorPorts" do

  before :each do
    $gom = Gom::Remote.connection = Object.new
    (Gom::Remote::Connection.stub! :new).and_return $gom
    ($gom.stub! :read).with('/gom/sensor-ports.json').and_return(<<-JSON)
      {
        "node": {
          "uri": "/services/viko/work",
          "mtime": "2010-01-06T15:14:57+01:00",
          "ctime": "2010-01-06T15:14:57+01:00",
          "entries": [
            { "attribute": {
              "name": "status",
              "node": "/services/viko/work",
              "value": "<void>",
              "type": "string",
              "mtime": "2010-01-07T19:30:36+01:00",
              "ctime": "2010-01-07T19:30:36+01:00"
            } }
          ]
        }
      }
    JSON
  end

  it "should dump status" do 
    station = Gom::SensorPorts.new '/gom/sensor-ports'
    station.status.should_not == nil
  end
end
