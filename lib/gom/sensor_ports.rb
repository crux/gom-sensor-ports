require 'applix/oattr'
require 'gom/remote'
require 'gom/log'
require 'gom/sensor_port'
require 'gom/sensor_ports/version'

module Gom
  class SensorPorts #< Gom::Remote::Entry

    Defaults = {
      :logfile      => '-',
      :interface    => '0.0.0.0',
      :sensor_port  => 76001,
      :mode         => :udp,
    }

    include OAttr
    oattr :logfile, :interface, :sensor_port, :mode

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

    def initialize path, options = {}
      @path = path
      @options = Defaults.merge(find_gom_node @path).merge(options)
      #puts " -- new sensor port: #{self.inspect}"
      Log.info "new sensor port: #{self.inspect}"

      #redirect_to logfile
    end

    def serve *args#path, opts = {}
      Log.info "listen: #{self.inspect}"
      self.send "listen_#{mode}"
    end

    def listen
      #puts " -- listen: #{self.inspect}"
      Log.info "listen: #{self.inspect}"
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
      Log.debug "-->#{line}<-- #{source.inspect}"
      key, value = (line.split /\s*[:=]\s*/)
      value.nil? or value.strip!
      # TODO: val might need type conversion
      Gom::Remote.connection.write "#{@path}:last_sensor_message", line
      Gom::Remote.connection.write "#{@path}/keys:#{key}", value
    end

    def status
      Log.debug @options.inspect
      "not implemented"
    end

    # TODO: must go into gom-script gem
    def redirect_to logfile
      #(@logfile_fd && @logfile_fd.close) rescue nil
      Log.debug "redirecting stdout/stderr to: #{logfile}"
      if logfile == '-'
        # redirect output back to original stdout/err stream can only be done
        # after a previous call has stored them in @stdout/@stderr member
        # variables
        if (@stdout && @stderr)
          #$stdout, $stderr = @stdout, @stderr
          STDOUT.reopen @stdout
          STDERR.reopen @stderr
        end
      else
        #@stdout, @stderr = STDOUT, STDERR #$stdout, $stderr
        #@logfile_fd = File.open(logfile, File::WRONLY|File::APPEND|File::CREAT)
        #@logfile_fd.sync = true
        ##$stderr = $stdout = @logfile_fd
        @stdout, @stderr = STDOUT.clone, STDERR.clone
        STDOUT.reopen logfile, 'a+'
        STDERR.reopen logfile, 'a+'
      end
      # first line after redirect
      Log.info "daemon logile redirect at #{Time.now}"
    end
  end
end

