module Gom
  class SensorPorts < Gom::Remote::Entry

    Defaults = {
      :logfile      => '-',
      :interface    => '0.0.0.0',
      :sensor_port  => 76001,
      :mode         => :udp,
    }

    include OAttr
    oattr :logfile, :interface, :sensor_port, :mode

    def initialize path, options = {}
      @path = path
      @options = Defaults.merge(gnode @path).merge(options)
      puts " -- new sensor port: #{self.inspect}"

      redirect_to logfile
    end

    def listen
      puts " -- listen: #{self.inspect}"
      self.send "listen_#{mode}"
    end

    def listen_udp
      socket = UDPSocket.new
      socket.bind(interface, sensor_port)
      loop do
        val, sender = socket.recvfrom(1024)
        puts "-->#{val}<-- #{sender.inspect}"
        # TODO: val might need type conversion
        gom.write "#{@path}:current_value", val.to_s.strip
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

    def redirect_to logfile
      (@logfile_fd && @logfile_fd.close) rescue nil
      puts " -- redirecting stdout/stderr to: #{logfile}"
      if logfile == '-'
        if @stdout
          $stderr, $stdout = @stdout, @stderr
        end
      else
        @stderr, @stdout = $stdout, $stderr
        @logfile_fd = File.open(logfile, File::WRONLY|File::APPEND|File::CREAT)
        @logfile_fd.sync = true
        $stderr = $stdout = @logfile_fd
      end
      # first line after redirect
      puts " -- daemon logile redirect at #{Time.now}"
    end

  end
end

