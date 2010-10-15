module Gom
  class SensorPorts < Gom::Remote::Entry

    Defaults = {
      :port   => 99123,
      :mode   =>  :udp,
    }

    include OAttr
    oattr :port, :user, :password

    def initialize path, options = {}
      @path = path
      @options = Defaults.merge(gnode @path).merge(options)
      puts " -- new sensor port: #{self.inspect}"
    end

    def listen
      puts "listen.."
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
