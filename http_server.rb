require 'socket'

$stdout.sync = true

server = TCPServer.new('0.0.0.0', 80)

puts "Server started on port 80"

loop do
  client = server.accept

  begin
    request = client.readpartial(2048)
    method, path, version = request.lines[0].split
    puts "#{method} #{path} #{version}"

    response_body = if path == "/healthcheck"
                      "OK"
                    else
                      "Well, hello there! How are you?"
                    end

    client.write("HTTP/1.1 200 OK\r\n")
    client.write("Content-Length: #{response_body.bytesize}\r\n")
    client.write("Connection: close\r\n")
    client.write("\r\n")
    client.write(response_body)
  rescue EOFError
    puts "Client closed the connection without sending data."
  ensure
    client.close
  end
end