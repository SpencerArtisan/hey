require 'cassandra'
require 'cassandra-cql'
include SimpleUUID

class Memory
  attr_accessor :description, :state, :priority, :id

  def initialize params = {}
    params = params.map {|k,v| {k.to_sym => v}}.reduce :merge
    params ||= {}
    self.description = params[:description]
    self.state = params[:state]
    self.priority = params[:priority]
    self.id = params[:id]
  end

  def self.all
    all = []  
    db.execute('select * from memory').fetch { |row| all << Memory.new(row.to_hash) }
    all
  end

  def self.delete_all
    db.execute 'truncate memory'
  end

  def save
    id = CassandraCQL::UUID.new.to_guid
    Memory.db.execute "insert into memory (id, description, state, priority) values ('#{id}', '#{description}', '#{state}', '#{priority}')"
  end

  def self.db
    CassandraCQL::Database.new '127.0.0.1:9160', keyspace: 'hey'
  end
end
