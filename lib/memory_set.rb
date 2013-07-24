require 'memory'

class MemorySet
  def initialize memories = []
    @memories = memories
  end

  def self.instance
    MemorySet.new Memory.all
  end

  def create description
    Memory.create description: description
  end

  def [] index
    @memories[index]
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
