require 'ostruct'

module SwitchSupport
  def process args = []
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

  def switches args
    self.class.switches.process self, args
  end

  def self.included(base)                                                         
    base.extend ClassMethods
  end

  module ClassMethods
    def switches &block
      @switch ||= Switch.new
      @switch.instance_eval &block if block_given?
      @switch
    end

    def all_switches
      @all_switches ||= {}
    end

    def switch code = :default, &block
      all_switches[code] = block
    end
  end
end
