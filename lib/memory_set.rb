# encoding: utf-8
require 'memory'
require 'forwardable'
require 'ostruct'

class MemorySet
  include Enumerable
  extend Forwardable
  def_delegators :active_memories, :[], :each

  def initialize memories = Memory.all
    @memories = memories
  end

  def create_group description
    create description, group: 'groups'
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

  def groups
    group_memories.each_with_index.map {|memory, i| summary(i, memory)}.join "\n"
  end

  def group_memories
    memories = @memories.select {|memory| memory.group == 'groups'}
    memories.sort_by! &:description
  end

  def group id
    group = group_memories[id]
    memories = @memories.select {|memory| memory.group == group.description}
    list = memories.each_with_index.map {|memory, i| summary(i, memory)}.join "\n"
    OpenStruct.new name: group.description, list: list
  end

  def to_s
    active_memories.each_with_index.map {|memory, i| summary(i, memory) if memory.priority != 'low'}.compact.join "\n"
  end

  def to_colourful_s
    active_memories.each_with_index.map {|memory, i| colourful_summary(i, memory) if memory.priority != 'low'}.compact.join "\n"
  end

  def to_s_full
    active_memories.each_with_index.map {|memory, i| summary(i, memory)}.join "\n"
  end

  def to_colourful_s_full
    active_memories.each_with_index.map {|memory, i| colourful_summary(i, memory)}.join "\n"
  end

  def active_memories
    @memories.select {|memory| memory.group == nil && memory.state != 'complete'}
  end

  def summary index, memory
    marker = case memory.priority
             when 'high' then '*'
             when 'low' then "↓"
             else ' '
             end
    "#{marker}#{index}. #{memory.description}"
  end

  def colourful_summary index, memory
    text = " #{index}. #{memory.description}"
    marker = case memory.priority
             when 'high' then text.red
             when 'low' then text.yellow
             else text.green
             end
  end
end
