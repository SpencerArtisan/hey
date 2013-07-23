require 'memory_set'

describe MemorySet do
  it 'should display a list of numbered memories' do
    subject << Memory.new(description: 'first')
    subject << Memory.new(description: 'second')
    subject.to_s.should == "1. first\n2. second"
  end
end
