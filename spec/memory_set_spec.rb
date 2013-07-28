# encoding: utf-8
require 'memory_set'

describe MemorySet do
  let(:memory) { stub.as_null_object }

  it 'should be a singleton object' do
    Memory.should_receive(:all).and_return [memory]
    expect(MemorySet.instance[0]).to eq(memory)
  end

  it 'should allow creation of a new memory' do
    Memory.should_receive(:create).with description: 'a memory'
    MemorySet.new.create 'a memory'
  end

  it 'should allow updating a memory' do
    update_params = stub
    Memory.stub all: [memory]
    memory.should_receive(:update).with update_params
    MemorySet.instance.update 0, update_params
  end

  it 'should allow deletion of a memory' do
    Memory.stub all: [memory]
    memory.should_receive :delete
    MemorySet.instance.delete 0
  end

  describe '#to_s' do
    it 'should display a list of numbered memories' do
      memory_set = MemorySet.new [stub(description: 'first').as_null_object,
                                  stub(description: 'second').as_null_object]
      expect(memory_set.to_s).to eq(" 0. first\n 1. second")
    end

    it 'should not show completed memories' do
      memory_set = MemorySet.new [stub(description: 'first', state: 'complete')]
      expect(memory_set.to_s).to be_empty
    end

    it 'should not show low priority memories' do
      memory_set = MemorySet.new [stub(description: 'first', priority: 'low').as_null_object]
      expect(memory_set.to_s).to be_empty
    end

    it 'should highlight high priority memories' do
      memory_set = MemorySet.new [stub(description: 'first', priority: 'high').as_null_object]
      expect(memory_set.to_s).to eq("*0. first")
    end
  end

  describe '#to_s_full' do
    it 'should highlight low priority memories' do
      memory_set = MemorySet.new [stub(description: 'first', priority: 'low').as_null_object]
      expect(memory_set.to_s_full).to eq("↓0. first")
    end
  end
end
