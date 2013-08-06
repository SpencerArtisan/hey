# encoding: utf-8
require 'memory'
require 'forwardable'

class MemorySet
  include Enumerable
  extend Forwardable
  def_delegators :@memories, :[], :each

  def initialize memories = Memory.all
    @memories = memories
  end

  def create description, other_attributes = {}
    Memory.create({description: description}.merge(other_attributes))
  end

  def delete index
    self[index].delete
  end

  def update index, params
    self[index].update params
  end

  def to_s
    active_memories.each_with_index.map {|memory, i| summary(i, memory) if memory.priority != 'low'}.compact.join "\n"
  end

  def to_s_full
    active_memories.each_with_index.map {|memory, i| summary(i, memory)}.join "\n"
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
