class Response
  attr_reader :code, :content_type, :data

  def initialize(code = 200, data = "", content_type = 'html')
    @code = code
    @content_type = CONTENT_TYPE_MAPPING[content_type]
    @data = data

    @response =
    "HTTP/1.1 #{code}\r\n" +
    "Content-Type: = #{@content_type}\r\n" +
    "Content-Length: #{data.size}\r\n" +
    "\r\n" +
    "#{data}\r\n"
  end

  def send(client)
    client.write(@response)
  end
end
