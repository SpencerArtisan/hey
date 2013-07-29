require 'memory_set'
require 'switch'
require 'ruby_ext'

class Hey
  include SwitchSupport

  switches do
    h :help
    l :low_priority, :list
    p :high_priority, :list
    c :complete, :list
    d :delete, :list
    f :full_list
    no_args :list
    default :create, :list
  end

  def execute args
    switches args
  end

  def delete args
    MemorySet.instance.delete id_arg(args)
  end

  def complete args
    MemorySet.instance.update id_arg(args), state: :complete
  end

  def list args
    MemorySet.instance.to_s
  end

  def full_list args
    MemorySet.instance.to_s_full
  end

  def low_priority args
    create_or_update args, 'low'
  end

  def high_priority args
    create_or_update args, 'high'
  end

  def create_or_update args, priority
    if has_id_arg? args
      MemorySet.instance.update id_arg(args), priority: priority
    else
      MemorySet.instance.create args[1..-1].join(' '), priority: priority
    end
  end

  def create args
    MemorySet.instance.create args.join(' ')
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
