class Module
  def alias_static_method *names
    names.each do |name|
      module_eval "def #{name}(*args) self.class.#{name}(*args); end"
    end
  end
end

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
