require 'memory_set'

class Hey
  def execute args
    switch = args[0]
    if switch == '-h'
      return help
    end

    memory_set = MemorySet.instance
    if switch == '-d'
      memory_set.delete args[1].to_i
    elsif switch == '-l'
      memory_set.update args[1].to_i, priority: :low
    elsif switch == '-p'
      memory_set.update args[1].to_i, priority: :high
    elsif switch == '-c'
      memory_set.update args[1].to_i, state: :complete
    elsif switch == '-f'
      return MemorySet.instance.to_s_full
    elsif !args.empty?
      memory_set.create args.join(' ')
    end

    MemorySet.instance.to_s
  end

  def help
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
