require "./boot"

TCPServer.open('localhost', DEFAULT_PORT) do |server|
  puts "Listening on #{DEFAULT_PORT}. Press CTRL+C to cancel."

  #if connection exists, run migrations
  loop do
    #serving multiple clients
    Thread.start(server.accept) do |client|
      request = client.readpartial(2048)
      request  = RequestParser.parse(request)
      response = ResponsePreparer.prepare(request)
      response.send(client)
      client.close
    end
  end
end
