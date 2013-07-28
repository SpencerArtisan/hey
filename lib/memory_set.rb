# encoding: utf-8
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

  def delete index
    self[index].delete
  end

  def update index, params
    self[index].update params
  end

  def [] index
    active_memories[index]
  end

  def length
    active_memories.length
  end

  def to_s
    list active_memories.select {|memory| memory.priority != 'low'}
  end

  def to_s_full
    list active_memories
  end

  def list memories
    memories.each_with_index.map {|memory, i| summary(i, memory)}.join "\n"
  end


  def active_memories
    @memories.select {|memory| memory.state != 'complete'}
  end

  def summary index, memory
    marker = case memory.priority
             when 'high' then '*'
             when 'low' then "↓"
             else ' '
             end
    "#{marker}#{index}. #{memory.description}"
  end
end
