require 'ostruct'

module SwitchSupport
  def execute args = []
    code = has_switch(args) ? get_switch(args) : :default
    block = self.class.all_switches[code]
    block.call args
  end

  def has_switch args
    args.length > 0 && args[0][0] == '-'
  end

  def get_switch args
    args[0][1].to_sym
  end

  def self.included(base)                                                         
    base.extend ClassMethods
  end

  module ClassMethods
    def all_switches
      @all_switches ||= {}
    end

    def switch code = :default, &block
      all_switches[code] = block
    end
  end
end
