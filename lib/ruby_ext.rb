class Time
  def midnight
    Time.new year, month, day, 0, 0, 0, 0
  end
end

class Module
  def alias_static_method *names
    names.each do |name|
      module_eval "def #{name}(*args) self.class.#{name}(*args); end"
    end
  end

  def attr_simple_accessor *names
    names.each do |name|
      module_eval %Q{
      def #{name} #{name} = nil
        return @#{name} unless #{name}
        @#{name} = #{name}
      end
      }
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

class String
  def is_integer?
    true if Integer(self) rescue false
  end

  def red
    colour 31
  end

  def green
    colour 36
  end

  def yellow
    colour 96
  end

  def inverse_green
    colour 46
  end

  def colour code
    replace "\e[#{code}m#{self}\e[0m"
  end
end
