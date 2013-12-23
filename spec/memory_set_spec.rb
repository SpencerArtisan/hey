# encoding: utf-8
require 'environment'
require 'memory_set'
require 'timecop'

describe MemorySet do
  let(:memory) { double(description: 'memory', group: nil).as_null_object }
  let(:memory2) { double(description: 'memory2', group: nil).as_null_object }

  it 'should initialise itself with all known memories' do
    Memory.stub all: [memory]
    expect(MemorySet.new.to_a).to eq [memory]
  end

  it 'should retrieve by index' do
    expect(MemorySet.new([memory])[0]).to eq memory
  end

  it 'should not include completed tasks when retrieving by index' do
    completed = double state: 'complete', group: nil, description: 'task'
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
    MemorySet.new([memory]).update [0], update_params
  end

  it 'should allow updating multiple memories' do
    update_params = double
    memory.should_receive(:update).with update_params
    memory2.should_receive(:update).with update_params
    MemorySet.new([memory, memory2]).update [0, 1], update_params
  end

  it 'should allow deletion of complete memories' do
    memory.stub state: 'complete'
    memory.should_receive :delete
    MemorySet.new([memory]).delete_complete
  end

  it 'should not allow deletion of incomplete memories' do
    memory.stub state: 'a state'
    memory.should_not_receive :delete
    MemorySet.new([memory]).delete_complete
  end

  it 'should allow deletion of a memory' do
    memory.should_receive :delete
    MemorySet.new([memory]).delete [0]
  end

  it 'should allow deletion of multiple memories' do
    memory.should_receive :delete
    memory2.should_receive :delete
    MemorySet.new([memory, memory2]).delete [0, 1]
  end

  it 'should allow completion of a memory' do
    memory.should_receive :complete
    MemorySet.new([memory]).complete [0]
  end

  it 'should allow completion of multiple memories' do
    memory.should_receive :complete
    memory2.should_receive :complete
    MemorySet.new([memory, memory2]).complete [0, 1]
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
      expect(MemorySet.new.groups).to eq " 0. first".green + "\n" + " 1. second".green
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
      expect(MemorySet.new.group(0).list).to eq ' 0. an item'.green
    end
  end

  describe '#to_s' do
    it 'should display normal priority memories in green' do
      memory_set = MemorySet.new [double(description: 'first', group: nil).as_null_object]
      expect(memory_set.to_s).to eq " 0. first".green
    end

    it 'should display high priority memories in red' do
      memory_set = MemorySet.new [double(description: 'first', group: nil, priority: 'high').as_null_object]
      expect(memory_set.to_s).to eq " 0. first".red
    end

    it 'should display low priority memories in yellow' do
      memory_set = MemorySet.new [double(description: 'first', group: nil, priority: 'low').as_null_object]
      expect(memory_set.to_s_full).to eq " 0. first".yellow
    end

    it 'should not display recently completed memories with blank completion dates' do
      Timecop.freeze(Time.local(2013, 12, 5, 14, 14, 0))
      memory_set = MemorySet.new [double(description: 'first', state: 'complete', completed_on: nil)]
      expect(memory_set.recently_completed).to eq ""
    end

    it 'should display recently completed memories for completions today' do
      Timecop.freeze(Time.local(2013, 12, 5, 14, 14, 0))
      memory_set = MemorySet.new [double(description: 'first', state: 'complete', completed_on: Time.now)]
      expect(memory_set.recently_completed).to eq(
        "Thursday 5 December".inverse_green + "\n " + "first".green + "\n")
    end

    it 'should display recently completed memories for completions yesterday' do
      Timecop.freeze(Time.local(2013, 12, 5, 14, 14, 0))
      memory_set = MemorySet.new [double(description: 'first', state: 'complete', completed_on: Time.now - 60*60*24)]
      expect(memory_set.recently_completed).to eq(
        "Wednesday 4 December".inverse_green + "\n " + "first".green + "\n")
    end

    it 'should display recently completed memories for two memories completed on different dates' do
      Timecop.freeze(Time.local(2013, 12, 5, 14, 14, 0))
      memory_set = MemorySet.new [double(description: 'first', state: 'complete', completed_on: Time.now),
                                  double(description: 'second', state: 'complete', completed_on: Time.now - 60*60*24)]
      expect(memory_set.recently_completed).to eq(
        "Wednesday 4 December".inverse_green + "\n " + "second".green + "\n" +
        "Thursday 5 December".inverse_green + "\n " + "first".green + "\n")
    end

    it 'should display most recently completed memories last' do
      Timecop.freeze(Time.local(2013, 12, 5, 14, 14, 0))
      memory_set = MemorySet.new [double(description: 'second', state: 'complete', completed_on: Time.now - 60*60*24),
                                  double(description: 'first', state: 'complete', completed_on: Time.now)]
      expect(memory_set.recently_completed).to eq(
        "Wednesday 4 December".inverse_green + "\n " + "second".green + "\n" +
        "Thursday 5 December".inverse_green + "\n " + "first".green + "\n")
    end

    it 'should display recently completed memories for two memories completed on the same date' do
      Timecop.freeze(Time.local(2013, 12, 5, 14, 14, 0))
      memory_set = MemorySet.new [double(description: 'first', state: 'complete', completed_on: Time.now),
                                  double(description: 'second', state: 'complete', completed_on: Time.now)]
      expect(memory_set.recently_completed).to eq(
        "Thursday 5 December".inverse_green + "\n " + "first".green + "\n " + "second".green + "\n")
    end

    it 'should display a list of numbered memories' do
      memory_set = MemorySet.new [double(description: 'first', group: nil).as_null_object,
                                  double(description: 'second', group: nil).as_null_object]
      expect(memory_set.to_s).to eq " 0. first".green + "\n" + " 1. second".green
    end

    it 'should not show completed memories' do
      memory_set = MemorySet.new [double(description: 'first', state: 'complete', group: nil)]
      expect(memory_set.to_s).to be_empty
    end

    it 'should not show low priority memories' do
      memory_set = MemorySet.new [double(description: 'first', priority: 'low', group: nil).as_null_object]
      expect(memory_set.to_s).to be_empty
    end

    it 'should number the same way for the full and partial list' do
      memory_set = MemorySet.new [double(description: 'first', priority: 'low', group: nil).as_null_object,
                                  double(description: 'second', group: nil).as_null_object]
      expect(memory_set.to_s).to eq " 1. second".green
    end

    it 'should be able to show only low priority memories' do
      memory_set = MemorySet.new [double(description: 'first', priority: 'low', group: nil).as_null_object,
                                  double(description: 'second', group: nil).as_null_object]
      expect(memory_set.to_s_low).to eq " 0. first".yellow
    end
  end
end
