class Hash
  def map! &block
    result = {}
    each do |k,v|
      mapped_key, mapped_value = block.call k, v
      result[mapped_key] = mapped_value
    end
    replace result
  end
end
