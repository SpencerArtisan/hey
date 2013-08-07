require 'switch'

class Subject
  include SwitchSupport

  switches do
    d :do_stuff
  end

  def do_stuff args
  end
end

describe Subject do
  let (:subject) { Subject.new }

  it 'should call the switch specific methods' do
    expect(subject).to receive(:do_stuff)
    subject.switches %w{-d}
  end
end
