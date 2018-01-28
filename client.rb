require 'socket'
require 'set'

class Client

  def initialize(server)
    @server = server
  end

  def run
    # Run till the listening thread finishes. When the connection closes, the
    # prompting thread is no longer needed.
    listener = listen
    send
    listener.join
  end

  private

    def listen
      Thread.start do
        while msg = @server.gets
          msg.chomp!
          puts "#{msg}"
        end
        puts "Connection closed"
        # Connection closed, thread finished.
      end
    end

    def send
      Thread.start do
        loop do
          msg = $stdin.gets.chomp
          @server.puts(msg)
        end
        # This never ends by itself.
      end
    end
end
