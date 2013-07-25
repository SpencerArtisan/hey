require 'cassandra_orm/database'
require 'cassandra'
require 'cassandra-cql'
require 'ruby_ext'
include SimpleUUID

module CassandraORM
  module Persistable
    attr_accessor :id

    def initialize params = {}
      params = self.class.defaults.merge(params) unless self.class.defaults.nil?
      params.each {|k,v| instance_eval("self.#{k} = '#{v}'")}
    end

    def delete
      database.execute "delete from #{column_family} where id='#{id}'"
    end

    def update params
      updates = params.map{|name, value| "#{name}='#{value}'"}.join ','
      database.execute "update #{column_family} set #{updates} where id='#{id}'"
      self.class.retrieve id
    end

    def column_family
      self.class.column_family
    end

    def database
      self.class.database
    end

    def self.included(base)                                                         
      base.extend ClassMethods
    end

    module ClassMethods
      def database database = nil
        return @database unless database
        @database = database
      end

      def defaults params = nil
        return @defaults unless params
        @defaults = params
      end

      def all
        all = []
        database.execute("select * from #{column_family}").fetch_hash{ |row| all << new(row) if row.length > 1 }
        all
      end

      def [] index
        self.all[index]
      end

      def retrieve id
        new database.execute("select * from #{column_family} where id=?", id).fetch_row.to_hash
      end

      def delete_all
        database.execute "truncate #{column_family}"
      end

      def create params = {}
        id = CassandraCQL::UUID.new.to_guid
        params = {id: id}.merge params
        columns = params.keys.join ','
        values = params.values.map {|value| "'#{value}'"}.join ','
        database.execute "insert into #{column_family} (#{columns}) values (#{values})"
        retrieve id
      end

      def apply_schema
        fields = new.methods.grep(/\w=$/) - methods.grep(/\w=$/)
        columns = fields.map {|field| "#{field[0..-2]} varchar"}.join ','
        begin
          database.execute "CREATE COLUMNFAMILY #{column_family} (id varchar PRIMARY KEY, #{columns})"
        rescue CassandraCQL::Error::InvalidRequestException
        end
      end

      def column_family
        name.downcase.split('::').last
      end
    end
  end
end
