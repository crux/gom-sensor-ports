module Gom
  class SensorPorts < Gom::Remote::Entry

    Defaults = {
      :port   => 99123,
      :mode   =>  :udp,
    }

    include OAttr
    oattr :port, :mode

    def initialize path, options = {}
      @path = path
      @options = Defaults.merge(gnode @path).merge(options)
      puts " -- new sensor port: #{self.inspect}"
    end

    def listen
      puts " -- listen: #{self.inspect}"
      self.send "listen_#{mode}"
    end

    def listen_udp
      socket = UDPSocket.new
      socket.bind(nil, port)
      loop do
        msg, sender = socket.recvfrom(1024)
        puts "-->#{msg}<-- #{sender.inspect}"
      end
    ensure
      socket.close rescue nil
    end

    def status
      puts @options.inspect
      #t = Net::Telnet::new(
      #  "Host" => device_ip, "Timeout" => 10, "Prompt" => /[$%#>] \z/n
      #)
      #t.login(user, password) { |c| puts c }
      "not implemented"
    end
  end
end

