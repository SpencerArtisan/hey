require 'memory_set'
require 'switch'
require 'ruby_ext'

class Hey
  include SwitchSupport

  switch :f do
    memories.to_colourful_s_full
  end

  switch :l do |args|
    if args.length == 1
      memories.to_colourful_s_low
    else
      create_or_update args, priority: 'low'
      memories.to_colourful_s
    end
  end

  switch :p do |args|
    create_or_update args, priority: 'high'
    memories.to_colourful_s
  end

  switch :c do |args|
    update id_arg(args), state: 'complete'
    memories.to_colourful_s
  end

  switch :d do |args|
    memories.delete id_arg(args)
    memories.to_colourful_s
  end

  switch do |args|
    create args unless args.empty?
    memories.to_colourful_s
  end

  switch :h do
    %q{
       hey                        list items
       hey an item description    create an item
       hey -d id                  delete item with given id
       hey -c id                  complete item with given id
       hey -l id                  make item with given id low priority
       hey -p id                  make item with given id high priority
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
    args.length > 1 && args[1].is_integer?
  end

  def self.id_arg args
    args[1].to_i
  end

  def self.memories
    MemorySet.new
  end
end
