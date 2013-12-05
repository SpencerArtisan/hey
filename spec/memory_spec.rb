require 'memory'

describe Memory do
  let (:memory) { Memory.new }
  let (:database) { double }

  before do
    Memory.database database
    CassandraCQL::UUID.stub new: (double to_guid: 'a guid')
  end

  it 'should update the state on completing' do
    database.should_receive(:execute).with "UPDATE memory SET state='complete' WHERE id='#{memory.id}'"
    memory.complete
  end
end
