require 'memory_set'
require 'switch'
require 'ruby_ext'

class Hey
  include SwitchSupport

  switch :f do
    memories.to_s_full
  end

  switch :r do
    memories.recently_completed
  end

  switch :l do |args|
    if args.length == 1
      memories.to_s_low
    else
      create_or_update args, priority: 'low'
      memories.to_s
    end
  end

  switch :p do |args|
    create_or_update args, priority: 'high'
    memories.to_s
  end

  switch :c do |args|
    memories.complete id_args(args)
    memories.recently_completed + "Remaining".inverse_green + "\n" + memories.to_s
  end

  switch :d do |args|
    memories.delete id_args(args)
    memories.to_s
  end

  switch :D do |args|
    memories.delete_complete
    memories.to_s
  end

  switch do |args|
    create args unless args.empty?
    memories.to_s
  end

  switch :h do
    %q{
       hey                        list items
       hey an item description    create an item
       hey -c id [other ids]      complete item with given id
       hey -l id [other ids]      make item with given id low priority
       hey -p id [other ids]      make item with given id high priority
       hey -d id [other ids]      delete item with given id
       hey -D                     delete completed items
       hey -r                     show recently completed items
    }
  end

  def self.create_or_update args, properties = {}
    if has_id_arg? args
      update id_args(args), properties
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

  def self.id_args args
    args[1..-1].map(&:to_i)
  end

  def self.memories
    MemorySet.new
  end
end
