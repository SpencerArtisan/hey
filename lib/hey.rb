require 'memory_set'
require 'switch'

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

  def delete args
    MemorySet.instance.delete args[1].to_i
  end

  def low_priority args
    MemorySet.instance.update args[1].to_i, priority: :low
  end

  def high_priority args
    MemorySet.instance.update args[1].to_i, priority: :high
  end

  def complete args
    MemorySet.instance.update args[1].to_i, state: :complete
  end

  def list args
    MemorySet.instance.to_s
  end

  def full_list args
    MemorySet.instance.to_s_full
  end

  def create args
    MemorySet.instance.create args.join(' ')
  end

  def execute args
    switches args
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
end
