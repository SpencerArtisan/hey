require 'memory_set'
require 'switch'
require 'ruby_ext'

class Hey
  include SwitchSupport

  switch :f do
    MemorySet.new.to_s_full
  end

  switch :l do |args|
    create_or_update args, priority: 'low'
    MemorySet.new.to_s
  end

  switch :p do |args|
    create_or_update args, priority: 'high'
    MemorySet.new.to_s
  end

  switch :c do |args|
    update id_arg(args), state: 'complete'
    MemorySet.new.to_s
  end

  switch :d do |args|
    MemorySet.new.delete id_arg(args)
    MemorySet.new.to_s
  end

  switch do |args|
    if args.empty?
      MemorySet.new.to_s
    else
      create args
    end
  end

  switch :h do
    %q{
       hey                       list items
       hey an item description   create an item
       hey -d id                 delete item with given id
       hey -c id                 complete item with given id
       hey -l id                 make item with given id low priority
       hey -p id                 make item with given id high priority
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
    MemorySet.new.create args.join(' '), properties
  end

  def self.update id, properties = {}
    MemorySet.new.update id, properties
  end

  def self.has_id_arg? args
    args.length == 2 && args[1].is_integer?
  end

  def self.id_arg args
    args[1].to_i
  end
end
