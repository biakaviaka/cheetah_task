def clean_string original_str
  original_str.to_s.gsub(/[^0-9A-Za-z]/, '').downcase
end
