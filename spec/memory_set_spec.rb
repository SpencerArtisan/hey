# encoding: utf-8
require 'memory_set'

describe MemorySet do
  let(:memory) { double.as_null_object }

  it 'should initialise itself with all known memories' do
    Memory.stub all: [memory]
    expect(MemorySet.new.to_a).to eq [memory]
  end

  it 'should retrieve by index' do
    expect(MemorySet.new([memory])[0]).to eq memory
  end

  it 'should not include completed tasks when retrieving by index' do
    completed = double state: 'complete'
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

  describe '#to_s' do
    it 'should display a list of numbered memories' do
      memory_set = MemorySet.new [double(description: 'first').as_null_object,
                                  double(description: 'second').as_null_object]
      expect(memory_set.to_s).to eq " 0. first\n 1. second"
    end

    it 'should not show completed memories' do
      memory_set = MemorySet.new [double(description: 'first', state: 'complete')]
      expect(memory_set.to_s).to be_empty
    end

    it 'should not show low priority memories' do
      memory_set = MemorySet.new [double(description: 'first', priority: 'low').as_null_object]
      expect(memory_set.to_s).to be_empty
    end

    it 'should highlight high priority memories' do
      memory_set = MemorySet.new [double(description: 'first', priority: 'high').as_null_object]
      expect(memory_set.to_s).to eq "*0. first"
    end

    it 'should number the same way for the full and partial list' do
      memory_set = MemorySet.new [double(description: 'first', priority: 'low').as_null_object,
                                  double(description: 'second').as_null_object]
      expect(memory_set.to_s).to eq " 1. second"
    end
  end

  describe '#to_s_full' do
    it 'should highlight low priority memories' do
      memory_set = MemorySet.new [double(description: 'first', priority: 'low').as_null_object]
      expect(memory_set.to_s_full).to eq "↓0. first"
    end
  end
end
