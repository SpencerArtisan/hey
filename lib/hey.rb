require 'memory_set'

class Switch < BasicObject
  def method_missing m, *args
    @switch_methods ||= {}
    @switch_methods[m] = args
  end

  def no_args *methods
    @no_args = methods
  end

  def default *methods
    @default = methods
  end

  def handle_switch instance, args
    methods = 
      if args.length == 0
        @no_args
      elsif has_switch(args)
        @switch_methods[get_switch(args)]
      else
        @default
      end
    result = nil
    methods.each {|method| result = instance.send method, args}
    result
  end

  def has_switch args
    args[0][0] == '-'
  end

  def get_switch args
    args[0][1].to_sym
  end
end

class Hey

  def self.switches &block
    @switch ||= Switch.new
    @switch.instance_eval &block if block_given?
    @switch
  end

  def switches args
    self.class.switches.handle_switch self, args
  end

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
