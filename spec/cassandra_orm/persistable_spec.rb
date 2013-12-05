require 'cassandra_orm/persistable'
require 'timecop'

module CassandraORM
  class TestPersistable
    include Persistable
    attr_accessor :field1, :field2
    defaults field1: 'default1'
  end

  describe Persistable do
    let (:database) { double }

    before do
      TestPersistable.database database
      CassandraCQL::UUID.stub new: (double to_guid: 'a guid')
      Timecop.freeze
    end

    describe '#new' do
      it 'should have properties set' do
        subject = TestPersistable.new id: 'an id', field1: 'field1', field2: 'field2'
        expect(subject.id).to eq 'an id'
        expect(subject.field1).to eq 'field1'
        expect(subject.field2).to eq 'field2'
      end

      it 'should support Time properties' do
        subject = TestPersistable.new field1: Time.now
        expect(subject.field1).to eq Time.now
      end

      it 'should have defaults' do
        subject = TestPersistable.new
        expect(subject.field1).to eq('default1')
        expect(subject.field2).to be_nil
      end
    end

    describe '#create' do
      it 'should be saved to the database' do
        database.should_receive(:execute).with "INSERT INTO testpersistable (id,field1,field2) VALUES ('a guid','field1','field2')"
        row = double(fetch_row: (double to_hash: {}))
        database.should_receive(:execute).with("SELECT * FROM testpersistable WHERE id='a guid'").and_return row
        TestPersistable.create field1: 'field1', field2: 'field2'
      end
    end

    describe '#retrieve' do
      it 'should be retrieved from the database' do
        row = double(fetch_row: (double to_hash: {id: 'an id', field1: 'field1', field2: 'field2'}))
        database.should_receive(:execute).with("SELECT * FROM testpersistable WHERE id='an id'").and_return row
        result = TestPersistable.retrieve 'an id'
        expect(result.id).to eq 'an id'
        expect(result.field1).to eq 'field1'
        expect(result.field2).to eq 'field2'
      end
    end

    describe '#update' do
      it 'should be updated in the database' do
        database.should_receive(:execute).with "UPDATE testpersistable SET field1='new field1',field2='new field2' WHERE id='a guid'"
        subject = TestPersistable.new id: 'a guid'
        subject.update field1: 'new field1', field2: 'new field2'
      end
    end

    describe '#delete' do
      it 'should be deletable' do
        database.should_receive(:execute).with "DELETE FROM testpersistable WHERE id='a guid'"
        subject = TestPersistable.new id: 'a guid'
        subject.delete
      end
    end
  end
end
