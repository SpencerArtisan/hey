require 'switch'

describe SwitchSupport do
  context 'Execution block' do
    before do
      class Subject
        include SwitchSupport
        switch :d do
          'do stuff'
        end
      end
      @subject = Subject.new
    end

    it 'should call the switch specific method' do
      expect(@subject.execute %w{-d}).to eq 'do stuff'
    end
  end

  context 'Arguments' do
    before do
      class Subject
        include SwitchSupport
        switch :d do |args|
           args 
        end
      end
      @subject = Subject.new
    end

    it 'should pass command line args through to the execution block' do
      expect(@subject.execute %w{-d arg1 arg2}).to eq ['-d', 'arg1', 'arg2']
    end
  end

  context 'Calling a default when no arguments are supplied' do
    before do
      class Subject
        include SwitchSupport
        switch do |args|
          args
        end
      end
      @subject = Subject.new
    end

    it 'should call the default switch when no args are supplied' do
      expect(@subject.execute %w{}).to eq []
    end

    it 'should call the default switch when args are supplied' do
      expect(@subject.execute %w{arg}).to eq ['arg']
    end
  end
end
