module RequestParser
  extend self

  def parse(request)
    method, path, version = request.lines[0].split
    {
      path: path,
      method: method,
      headers: parse_headers(request)
    }
  end

  def parse_headers(request)
    headers = {}
    request.lines[1..-1].each do |line|
      return headers if line == "\r\n"
      header, value = line.split
      header = normalize(header)
      headers[header] = value
    end
  end

  def normalize(header)
    header.gsub(":", "").downcase.to_sym
  end
end
