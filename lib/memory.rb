require 'cassandra'
require 'cassandra-cql'
require 'database'
require 'ruby_ext'
include SimpleUUID
include Database

class Memory
  attr_accessor :description, :state, :priority, :id
  #include Cassandra::Persistable

  def initialize params = {}
    params.map! {|k,v| [k.to_sym, v]}
    self.description = params.fetch :description
    self.state = params.fetch :state, 'Not started'
    self.priority = params.fetch :priority, 'Medium'
    self.id = params.fetch :id, CassandraCQL::UUID.new.to_guid
  end

  def self.all
    all = []
    db.execute('select * from memory').fetch_hash{ |row| all << Memory.new(row) if row.length > 1 }
    all.sort {|x, y| x.description <=> y.description}
  end

  def self.[] index
    self.all[index]
  end

  def delete
    db.execute "delete from memory where id='#{id}'"
  end

  def update params
    updates = params.map{|name, value| "#{name}='#{value}'"}.join ','
    db.execute "update memory set #{updates} where id='#{id}'"
    Memory.retrieve id
  end

  def self.retrieve id
    Memory.new db.execute('select * from memory where id=?', id).fetch_row.to_hash
  end

  def self.delete_all
    db.execute 'truncate memory'
  end

  def self.create params = {}
    memory = Memory.new params
    db.execute "insert into memory (id, description, state, priority) values ('#{memory.id}', '#{memory.description}', '#{memory.state}', '#{memory.priority}')"
    memory
  end

  def to_s
    "#{id}. #{description}"
  end
end
