require 'main'
require 'memory_set'
require 'ruby_ext'
require 'cassandra_orm/database'
require 'memory'

Memory.database CassandraORM::Database.database('127.0.0.1:9160', 'hey_prod')

Main do
  argument('id'){ 
    optional
    cast :int
  }
  argument('description'){ 
    optional
  }
  option 'full', 'f'
  option 'low', 'l'

  def run
    p params[:id]
    p params[:description]

    if params[:low].given?
      create_or_update args, 'low'
    end

    if params[:full].given?
      puts MemorySet.new.to_s_full
    else
      puts MemorySet.new.to_s
    end
    exit_success!
  end

  def create_or_update args, priority
    if params[:id].given?
      MemorySet.new.update params[:id], priority: priority
    else
      MemorySet.new.create args[1..-1].join(' '), priority: priority
    end
  end
end
