require 'memory_set'

class Hey
  def execute args
    memory_set = MemorySet.instance

    if args.empty?
      memory_set.to_s
    elsif args[0] == '-d'
      memory_set.delete args[1].to_i
    elsif args[0] == '-h'
      memory_set.update args[1].to_i, priority: :high
    elsif args[0] == '-c'
      memory_set.update args[1].to_i, status: :complete
    elsif args[0] == '-p'
      memory_set.save_remote
    elsif args[0] == '-help'
      help
    else
      memory_set.create args.join(' ')
    end
  end

  def help
    %q{
       hey                       list items
       hey an item description   create an item
       hey -d id                 delete item with given id
       hey -c id                 complete item with given id
       hey -h id                 make item with given id high priority
    }
  end
end
