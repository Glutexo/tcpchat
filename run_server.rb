require_relative 'server'

server = Server.new('localhost', 3000)
server.run
