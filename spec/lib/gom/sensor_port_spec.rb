require 'spec_helper'

describe "Gom::SensorPort" do
  context "given no options" do

    let(:path) { '/gom-sensor-port' }
    let(:station) { Gom::SensorPort.new "#{path}" }
    let(:json) { <<-JSON
      {
        "node": {
          "uri": "#{path}",
          "entries": [
            { "attribute": {
              "name": "status",
              "node": "#{path}",
              "value": "<void>", "type": "string"
            } }
          ]
        }
      }
      JSON
    }

    before :each do
      ($gom.stub! :read).with("#{path}.json").and_return(json)
    end

    describe "#dispatch_sensor_message" do
      it "writes sensor value to gom" do
        $gom.should_receive(:write).
          with("#{path}:last_sensor_message", "foo:123")
        $gom.should_receive(:write).
          with("#{path}/keys:foo", "123")
        station.dispatch_sensor_message "foo:123"
      end
    end

    describe ".initialize" do
      it "has a default interface" do
        station.interface.should == '0.0.0.0'
      end

      it "defaults to udp mode" do
        station.mode.should == :udp
      end

      it "configures sensor port on 76001" do
        station.port.should == 44470
      end
    end
  end
end
