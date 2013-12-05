require 'cassandra_orm/database'
require 'cassandra'
require 'cassandra-cql'
require 'ruby_ext'
require 'cassandra_orm/cassandra-cql'
include SimpleUUID

module CassandraORM
  module Persistable
    attr_accessor :id
    alias_static_method :column_family, :database

    def initialize params = {}
      params = self.class.defaults.merge(params) if self.class.defaults
      params.each {|k,v| instance_eval("@#{k} = '#{v}'")}
    end

    def delete
      database.execute "DELETE FROM #{column_family} WHERE id='#{id}'"
    end

    def update params
      updates = params.map{|name, value| "#{name}='#{value}'"}.join ','
      database.execute "UPDATE #{column_family} SET #{updates} WHERE id='#{id}'"
    end

    def self.included(base)                                                         
      base.extend ClassMethods
    end

    module ClassMethods
      attr_simple_accessor :database, :defaults

      def all
        database.execute("SELECT * FROM #{column_family}").all_hash_rows.map{ |row| new(row) }
      end

      def [] index
        self.all[index]
      end

      def retrieve id
        new database.execute("SELECT * FROM #{column_family} WHERE id='#{id}'").fetch_row.to_hash
      end

      def delete_all
        database.execute "TRUNCATE #{column_family}"
      end

      def create params = {}
        params = assign_id params
        columns = params.keys.join ','
        values = params.values.map {|value| "'#{value}'"}.join ','
        database.execute "INSERT INTO #{column_family} (#{columns}) VALUES (#{values})"
        retrieve params[:id]
      end

      def assign_id params
        id = CassandraCQL::UUID.new.to_guid
        {id: id}.merge params
      end

      def apply_schema
        fields = new.methods.grep(/\w=$/) - methods.grep(/\w=$/)
        columns = fields.map {|field| "#{field[0..-2]} VARCHAR"}.join ','
        begin
          database.execute "CREATE COLUMNFAMILY #{column_family} (id VARCHAR PRIMARY KEY, #{columns})"
        rescue CassandraCQL::Error::InvalidRequestException
        end
      end

      def column_family
        name.downcase.split('::').last
      end
    end
  end
end
