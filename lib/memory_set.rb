require 'memory'

class MemorySet
  include Enumerable

  def initialize
    @memories = []
  end

  def << memory
    @memories << memory
  end

  def [] index
    @memories[index]
  end

  def each
    @memories.each
  end

  def length
    @memories.length
  end

  def to_s
    @memories.each_with_index.map {|memory, i| summary(i + 1, memory)}.join "\n"
  end

  def summary index, memory
    "#{index}. #{memory.description}"
  end
end
