require 'memory'

describe Memory do
  before do
    Memory.delete_all
  end

  describe '#new' do
    let (:memory) { Memory.new description: 'a description', state: 'a state', priority: 'a priority' }

    it 'should have properties set' do
      expect(memory.description).to eq('a description')
      expect(memory.state).to eq('a state')
      expect(memory.priority).to eq('a priority')
    end
  end

  describe '#create' do
    it 'should be saved to the database' do
      Memory.create description: 'a description', state: 'a state', priority: 'a priority'
      memory = Memory[0]
      expect(memory.description).to eq('a description')
      expect(memory.state).to eq('a state')
      expect(memory.priority).to eq('a priority')
    end

    context 'multiple item persistence' do
      it 'should create multiple memories' do
        Memory.create
        Memory.create
        expect(Memory.all).to have(2).items
      end

      it 'should create with unique ids' do
        Memory.create
        Memory.create
        expect(Memory[0].id).not_to eq(Memory[1].id)
      end
    end
  end

  describe '#update' do
    it 'should be updated in the database' do
      memory = Memory.create description: 'a description', state: 'a state', priority: 'a priority'
      memory.update description: 'a new description', state: 'a new state', priority: 'a new priority'
      memory = Memory[0]
      expect(memory.description).to eq('a new description')
      expect(memory.state).to eq('a new state')
      expect(memory.priority).to eq('a new priority')
    end
  end

  describe '#delete' do
    it 'should be deletable' do
      Memory.create.delete
      expect(Memory.all).to be_empty
    end
  end
end
