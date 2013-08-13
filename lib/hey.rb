require 'memory_set'
require 'switch'
require 'ruby_ext'

class Hey
  include SwitchSupport

  switch :f do
    memories.to_s_full
  end

  switch :g do |args|
    if args.length == 1
      memories.groups
    else
      memories.create_group args[1..-1].join(' ')
    end
  end

  switch :l do |args|
    create_or_update args, priority: 'low'
    memories.to_s
  end

  switch :p do |args|
    create_or_update args, priority: 'high'
    memories.to_s
  end

  switch :c do |args|
    update id_arg(args), state: 'complete'
    memories.to_s
  end

  switch :d do |args|
    memories.delete id_arg(args)
    memories.to_s
  end

  switch do |args|
    if args.empty?
      memories.to_s
    else
      create args
    end
  end

  switch :h do
    %q{
       hey                        list items
       hey an item description    create an item
       hey -d id                  delete item with given id
       hey -c id                  complete item with given id
       hey -l id                  make item with given id low priority
       hey -p id                  make item with given id high priority
       hey -g                     list groups
       hey -g a group description create a group
    }
  end

  def self.create_or_update args, properties = {}
    if has_id_arg? args
      update id_arg(args), properties
    else
      create args[1..-1], properties
    end
  end

  def self.create args, properties = {}
    memories.create args.join(' '), properties
  end

  def self.update id, properties = {}
    memories.update id, properties
  end

  def self.has_id_arg? args
    args.length == 2 && args[1].is_integer?
  end

  def self.id_arg args
    args[1].to_i
  end

  def self.memories
    MemorySet.new
  end
end
