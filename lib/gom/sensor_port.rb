require 'socket'

module Gom
  class SensorPort 

    Defaults = {
      :interface  => '0.0.0.0',
      :port       => 44470,
      :mode       => :udp,
    }

    include OAttr
    oattr :interface, :port, :mode

    def initialize path, options = {}
      @path = path
      @options = Defaults.merge(find_gom_node @path).merge(options)
      #puts " -- new sensor port: #{self.inspect}"
      Log.info "new sensor port: #{self.inspect}"
    end

    def listen
      #puts " -- listen: #{self.inspect}"
      Log.info "listen: #{self.inspect}"
      self.send "listen_#{mode}"
    end

    def listen_udp
      socket = UDPSocket.new
      socket.bind(interface, port)
      loop do
        line, source = socket.recvfrom(1024)
        dispatch_sensor_message line, source
      end
    ensure
      socket.close rescue nil
    end

    def listen_tcp
      raise "not yet implemented"
    end

    def dispatch_sensor_message line, source = nil
      line.strip!
      Log.debug "-->#{line}<-- #{source.inspect}"
      key, value = (line.split /\s*[:=]\s*/)
      value.nil? or value.strip!
      # TODO: val might need type conversion
      Gom::Remote.connection.write "#{@path}:last_sensor_message", line
      Gom::Remote.connection.write "#{@path}/keys:#{key}", value
    end

    # TODO: temporarily here from gom-script
    def find_gom_node path
      json = (Gom::Remote.connection.read "#{path}.json")
      (JSON.parse json)["node"]["entries"].select do |entry|
        # 1. select attribute entries
        entry.has_key? "attribute"
      end.inject({}) do |h, a|
          # 2. make it a key, value list
          h[a["attribute"]["name"].to_sym] = a["attribute"]["value"]
          h
      end
    end
  end
end

