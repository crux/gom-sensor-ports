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
      puts "-->#{line}<-- #{source.inspect}"
      key, value = (line.split /\s*[:=]\s*/)
      value.nil? or value.strip!
      # TODO: val might need type conversion
      gom.write "#{@path}:last_sensor_message", line
      gom.write "#{@path}/keys:#{key}", value
    end

    def status
      puts @options.inspect
      "not implemented"
    end

    # todo: must go into gom-script gem
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

