require 'switch'

describe SwitchSupport do
  context 'Calling one method' do
    before do
      class Subject
        include SwitchSupport
        switches { d call: :do_stuff }
      end
      @subject = Subject.new
    end

    it 'should call the switch specific method' do
      expect(@subject).to receive :do_stuff
      @subject.switches %w{-d}
    end
  end

  context 'Calling many methods' do
    before do
      class Subject
        include SwitchSupport
        switches { d calls: [:do_stuff, :do_more_stuff] }
      end
      @subject = Subject.new
    end

    it 'should call the switch specific method' do
      expect(@subject).to receive :do_stuff
      expect(@subject).to receive :do_more_stuff
      @subject.switches %w{-d}
    end
  end

  context 'Calling a default when no arguments are supplied' do
    before do
      class Subject
        include SwitchSupport
        switches { no_args call: :do_stuff }
      end
      @subject = Subject.new
    end

    it 'should call the switch specific method' do
      expect(@subject).to receive :do_stuff
      @subject.switches %w{}
    end
  end

  context 'Calling a default when arguments are supplied' do
    before do
      class Subject
        include SwitchSupport
        switches { default call: :do_stuff }
      end
      @subject = Subject.new
    end

    it 'should call the switch specific method' do
      expect(@subject).to receive :do_stuff
      @subject.switches %w{some args}
    end
  end
end
