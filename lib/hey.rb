require 'memory_set'
require 'switch'
require 'ruby_ext'

class Hey
  include SwitchSupport

  switches do
    h call: :help
    l calls: [:low_priority, :list]
    p calls: [:high_priority, :list]
    c calls: [:complete, :list]
    d calls: [:delete, :list]
    f call: :full_list
    no_args call: :list
    default calls: [:create, :list]
  end

  def execute args
    switches args
  end

  def delete args
    MemorySet.new.delete id_arg(args)
  end

  def complete args
    MemorySet.new.update id_arg(args), state: :complete
  end

  def list args
    MemorySet.new.to_s
  end

  def full_list args
    MemorySet.new.to_s_full
  end

  def low_priority args
    create_or_update args, 'low'
  end

  def high_priority args
    create_or_update args, 'high'
  end

  def create_or_update args, priority
    if has_id_arg? args
      MemorySet.new.update id_arg(args), priority: priority
    else
      MemorySet.new.create args[1..-1].join(' '), priority: priority
    end
  end

  def create args
    MemorySet.new.create args.join(' ')
  end

  def help args
    %q{
       hey                       list items
       hey an item description   create an item
       hey -d id                 delete item with given id
       hey -c id                 complete item with given id
       hey -l id                 make item with given id low priority
       hey -p id                 make item with given id high priority
    }
  end

  def has_id_arg? args
    args.length == 2 && args[1].is_integer?
  end

  def id_arg args
    args[1].to_i
  end
end
