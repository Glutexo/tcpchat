require_relative 'client'

server = TCPSocket.open('localhost', 3000)
client = Client.new(server)
client.run
