require 'socket'

class Server
  def initialize(ip, port)
    @server = TCPServer.open(ip, port)
    @clients = {}
  end

  def run
    # No need to join the threads, the main process is waiting for new
    # connections.

    loop do
      puts('Waiting for connection')

      Thread.start(@server.accept) do |client|
        puts("Connected #{client}")
        client.puts('Username:')
        username = client.gets.chomp

        if @clients.has_key?(username) || @clients.has_value?(client)
          client.puts('This username already exists')
          client.close # Tell the client that we’re done.
          Thread.current.kill # Kill the thread and leave the block.
        end

        @clients[username] = client
        puts("Joined #{username} #{client}")
        client.puts("Welcome, #{username}!")

        listen(username, client)
      end
    end
  end

  def listen(username, client)
    loop do
      msg = client.gets.chomp

      # Broadcast message to all clients but self
      @clients.each do |other_username, other_client|
        unless other_username == username
          other_client.puts "#{username.to_s}: #{msg}"
        end
      end
    end
  end
end
