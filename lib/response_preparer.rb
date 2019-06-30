module ResponsePreparer
  extend self

  def prepare(request)
    case request.fetch(:path)
    when "/"
      respond_with(SERVER_ROOT + "index.html")
    when "/update_catalog"
      response = {updated: 0, inserted: 0}
      CSV.foreach(MOCK_FILE, {:headers => true, :header_converters => :symbol}) do |row|
        current_response = Product.new(row).insert_or_update
        response[current_response[:action].to_sym] += current_response[:amount]
      end

      respond_with("Updated: #{response[:updated]} rows, inserted #{response[:inserted]} rows")
    when /^(\/get_catalog)\/(?<producer>[^\/]*)\/(?<page>[0-9]+)/
      data = Product.get_products_by_producer($LAST_MATCH_INFO['producer'], $LAST_MATCH_INFO['page'])

      respond_with(data, 'json')
    else
      respond_with(SERVER_ROOT + "404.html", 'html', 404)
    end
  end

  def respond_with(data, content_type = "html", code = 200)
    if File.exists?(data)
      Response.new(code, File.binread(data), content_type)
    elsif content_type == 'json'
      if ! valid_json?(data)
        content_type = 'html'
        data = "Response is not valid JSON"
      end

      Response.new(code, data, content_type)
    else
      Response.new(code, data, content_type)
    end
  end

  def valid_json?(json)
    !!JSON.parse(json)
  rescue JSON::ParserError => _e
    false
  end
end
