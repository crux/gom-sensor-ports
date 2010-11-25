require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Gom::SensorPorts" do
  context "given no options" do

    NODE = '/gom-sensor-ports'

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
      @station = Gom::SensorPorts.new "#{NODE}"
    end

    #describe "#listen_tcp" do
    #  expect { @station.listen_tcp }.to raise_error#(ActiveRecord::RecordNotFound)
    #end

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

      it "logs to stdout" do
        @station.logfile.should == '-'
      end

      it "defaults to udp mode" do
        @station.mode.should == :udp
      end

      it "configures sensor port on 76001" do
        @station.sensor_port.should == 76001
      end
    end

    describe "#status" do
      it "dumps status to stdout" do 
        @station.status.should be
      end
    end
  end
end
