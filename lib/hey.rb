require 'memory'

class Hey
  def execute args
    if args.empty?
      Memory.all.to_s
    elsif args[0] == '-d'
      Memory.delete args[1].to_i
    elsif args[0] == '-h'
      Memory.update args[1].to_i, priority: :high
    elsif args[0] == '-c'
      Memory.update args[1].to_i, status: :complete
    elsif args[0] == '-p'
      Memory.save_remote
    elsif args[0] == '-help'
      help
    else
      Memory.create description: args.join(' ')
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
