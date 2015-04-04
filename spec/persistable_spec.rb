require 'timecop'
require 'persistable'

class TestPersistable
    include Persistable
    attr_accessor :field1, :field2
    defaults field1: 'default1'
end

describe Persistable do
    before do
      Timecop.freeze
      TestPersistable.delete_all
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

    describe '#[]' do
      it 'should be retrieved by index' do
        created = TestPersistable.create field1: 'field1', field2: 'field2'
        createdb = TestPersistable.create field1: 'field1b', field2: 'field2b'
        result = TestPersistable[0]
        expect(result.id).to eq created.id
        expect(result.field1).to eq 'field1'
        expect(result.field2).to eq 'field2'
        result = TestPersistable[1]
        expect(result.id).to eq createdb.id
        expect(result.field1).to eq 'field1b'
        expect(result.field2).to eq 'field2b'
      end
    end

    describe '#retrieve' do
      it 'should be retrieved by id' do
        created = TestPersistable.create field1: 'field1', field2: 'field2'
        createdb = TestPersistable.create field1: 'field1b', field2: 'field2b'
        result = TestPersistable.retrieve created.id
        expect(result.id).to eq created.id
        expect(result.field1).to eq 'field1'
        expect(result.field2).to eq 'field2'
        result = TestPersistable.retrieve createdb.id
        expect(result.id).to eq createdb.id
        expect(result.field1).to eq 'field1b'
        expect(result.field2).to eq 'field2b'
      end
    end

    describe '#update' do
      it 'should be updated' do
        created = TestPersistable.create field1: 'field1', field2: 'field2'
        createdb = TestPersistable.create field1: 'field1b', field2: 'field2b'
        subject = TestPersistable.new id: created.id
        subject.update field1: 'new field1', field2: 'new field2'
        result = TestPersistable.retrieve created.id
        expect(result.id).to eq created.id
        expect(result.field1).to eq 'new field1'
        expect(result.field2).to eq 'new field2'
        result = TestPersistable.retrieve createdb.id
        expect(result).not_to be_nil
      end
    end

    describe '#delete' do
      it 'should be deleted' do
        created = TestPersistable.create field1: 'field1', field2: 'field2'
        createdb = TestPersistable.create field1: 'field1b', field2: 'field2b'
        subject = TestPersistable.new id: created.id
        subject.delete
        result = TestPersistable.retrieve created.id
        expect(result).to be_nil
        result = TestPersistable.retrieve createdb.id
        expect(result).not_to be_nil
      end
    end

    describe '#delete_all' do
      it 'should delete all' do
        created = TestPersistable.create field1: 'field1', field2: 'field2'
        createdb = TestPersistable.create field1: 'field1b', field2: 'field2b'
        TestPersistable.delete_all
        result = TestPersistable.all
        expect(result).to be_empty
      end
    end

    describe '#all' do
      it 'should retrieve all' do
        created = TestPersistable.create field1: 'field1', field2: 'field2'
        createdb = TestPersistable.create field1: 'field1b', field2: 'field2b'
        result = TestPersistable.all
        expect(result).to have(2).items
        expect(result[0].id).to eq created.id
        expect(result[0].field1).to eq 'field1'
        expect(result[0].field2).to eq 'field2'
        expect(result[1].id).to eq createdb.id
        expect(result[1].field1).to eq 'field1b'
        expect(result[1].field2).to eq 'field2b'
      end
    end
end
