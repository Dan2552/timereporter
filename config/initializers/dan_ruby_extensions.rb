class Array
  def where options={}
    collection = map do |item| 
      match = true
      options.each{ |k,v| match = match && (item.send(k) == v) }
      match ? item : nil
    end.compact
  end
end

class Object

  def if_present
    return false unless present?
    self
  end

  def to_b
    true_values.include? self
  end

  private

  def true_values
    [true, 1, '1', 't', 'T', 'true', 'TRUE']
  end

end
