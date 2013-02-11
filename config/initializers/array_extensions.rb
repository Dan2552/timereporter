class Array
  def where options={}
    collection = map do |item| 
      match = true
      options.each{ |k,v| match = match && (item.send(k) == v) }
      match ? item : nil
    end.compact
  end
end
