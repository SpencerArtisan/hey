require 'environment'
require 'memory'
require 'timecop'

describe Memory do
  let (:memory) { Memory.create description: 'test' }

  before do
    Timecop.freeze
  end

  it 'should update the state on completing' do
    memory.complete
    retrieved_memory = Memory.retrieve memory.id
    expect(retrieved_memory.state).to eq('complete')
  end

  it 'should record the completion time' do
    memory.complete
    retrieved_memory = Memory.retrieve memory.id
    expect(retrieved_memory.completed_on.to_i).to eq(Time.now.to_i)
  end
end
