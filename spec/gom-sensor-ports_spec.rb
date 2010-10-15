require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "GomSensorPorts" do
  it "should require service" do
    Gom::SensorPorts.should_not == nil
  end
end
