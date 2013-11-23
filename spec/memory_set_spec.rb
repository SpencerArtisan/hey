# encoding: utf-8
require 'environment'
require 'memory_set'

describe MemorySet do
  let(:memory) { double(group: nil).as_null_object }

  it 'should initialise itself with all known memories' do
    Memory.stub all: [memory]
    expect(MemorySet.new.to_a).to eq [memory]
  end

  it 'should retrieve by index' do
    expect(MemorySet.new([memory])[0]).to eq memory
  end

  it 'should not include completed tasks when retrieving by index' do
    completed = double state: 'complete', group: nil
    expect(MemorySet.new([completed, memory])[0]).to eq memory
  end

  it 'should allow creation of a new memory' do
    Memory.stub all: []
    Memory.should_receive(:create).with description: 'a memory'
    MemorySet.new.create 'a memory'
  end

  it 'should allow creation of a new memory with low priority' do
    Memory.stub all: []
    Memory.should_receive(:create).with description: 'a memory', priority: 'low'
    MemorySet.new.create 'a memory', priority: 'low'
  end

  it 'should allow updating a memory' do
    update_params = double
    memory.should_receive(:update).with update_params
    MemorySet.new([memory]).update 0, update_params
  end

  it 'should allow deletion of a memory' do
    memory.should_receive :delete
    MemorySet.new([memory]).delete 0
  end

  describe '#groups' do
    before do
      Memory.database CassandraORM::Database.database
      Memory.delete_all
    end

    it 'should return a list of groups' do
      memory_set = MemorySet.new []
      memory_set.create_group 'first'
      memory_set.create_group 'second'
      expect(MemorySet.new.groups).to eq " 0. first\n 1. second"
    end

    it 'should retrieve a group by id' do
      memory_set = MemorySet.new []
      memory_set.create_group 'first'
      memory_set.create_group 'second'
      expect(MemorySet.new.group(0).name).to eq 'first'
      expect(MemorySet.new.group(1).name).to eq 'second'
    end

    it 'should convert a group to a list of items in that group' do
      memory_set = MemorySet.new []
      memory_set.create_group 'first'
      memory_set.create 'an item', group: 'first'
      expect(MemorySet.new.group(0).list).to eq ' 0. an item'
    end
  end

  describe '#to_colourful_s' do
    it 'should display normal priority memories in green' do
      memory_set = MemorySet.new [double(description: 'first', group: nil).as_null_object]
      expect(memory_set.to_colourful_s).to eq " 0. first".green
    end

    it 'should display high priority memories in red' do
      memory_set = MemorySet.new [double(description: 'first', group: nil, priority: 'high').as_null_object]
      expect(memory_set.to_colourful_s).to eq " 0. first".red
    end

    it 'should display low priority memories in yellow' do
      memory_set = MemorySet.new [double(description: 'first', group: nil, priority: 'low').as_null_object]
      expect(memory_set.to_colourful_s_full).to eq " 0. first".yellow
    end
  end

  describe '#to_s' do
    it 'should display a list of numbered memories' do
      memory_set = MemorySet.new [double(description: 'first', group: nil).as_null_object,
                                  double(description: 'second', group: nil).as_null_object]
      expect(memory_set.to_s).to eq " 0. first\n 1. second"
    end

    it 'should not show completed memories' do
      memory_set = MemorySet.new [double(description: 'first', state: 'complete', group: nil)]
      expect(memory_set.to_s).to be_empty
    end

    it 'should not show low priority memories' do
      memory_set = MemorySet.new [double(description: 'first', priority: 'low', group: nil).as_null_object]
      expect(memory_set.to_s).to be_empty
    end

    it 'should highlight high priority memories' do
      memory_set = MemorySet.new [double(description: 'first', priority: 'high', group: nil).as_null_object]
      expect(memory_set.to_s).to eq "*0. first"
    end

    it 'should number the same way for the full and partial list' do
      memory_set = MemorySet.new [double(description: 'first', priority: 'low', group: nil).as_null_object,
                                  double(description: 'second', group: nil).as_null_object]
      expect(memory_set.to_s).to eq " 1. second"
    end

    it 'should be able to show only low priority memories' do
      memory_set = MemorySet.new [double(description: 'first', priority: 'low', group: nil).as_null_object,
                                  double(description: 'second', group: nil).as_null_object]
      expect(memory_set.to_colourful_s_low).to eq " 0. first".yellow
    end
  end

  describe '#to_s_full' do
    it 'should highlight low priority memories' do
      memory_set = MemorySet.new [double(description: 'first', priority: 'low', group: nil).as_null_object]
      expect(memory_set.to_s_full).to eq "↓0. first"
    end
  end
end
