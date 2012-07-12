require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Gom::SensorPort" do
  context "given no options" do

    NODE = '/gom-sensor-port'

    before :each do
      ($gom.stub! :read).with("#{NODE}.json").and_return(<<-JSON)
      {
        "node": {
          "uri": "#{NODE}",
          "entries": [
            { "attribute": {
              "name": "status",
              "node": "#{NODE}",
              "value": "<void>", "type": "string"
            } }
          ]
        }
      }
    JSON
      @station = Gom::SensorPort.new "#{NODE}"
    end

    describe "#dispatch_sensor_message" do
      it "writes sensor value to gom" do
        $gom.should_receive(:write).
          with("#{NODE}:last_sensor_message", "foo:123")
        $gom.should_receive(:write).
          with("#{NODE}/keys:foo", "123")
        @station.dispatch_sensor_message "foo:123"
      end
    end

    describe ".initialize" do
      it "has a default interface" do
        @station.interface.should == '0.0.0.0'
      end

      it "defaults to udp mode" do
        @station.mode.should == :udp
      end

      it "configures sensor port on 76001" do
        @station.port.should == 44470
      end
    end
  end
end
