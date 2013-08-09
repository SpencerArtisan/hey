require 'ostruct'

class Switch < BasicObject
  def method_missing m, options
    @switch_methods ||= {}
    @switch_methods[m] = options[:calls] || [options[:call]]
  end

  def process instance, args
    switch = 
      if args.length == 0
        :no_args
      elsif has_switch(args)
        get_switch(args)
      else
        :default
      end
    result = nil
    methods = @switch_methods[switch]
    methods.each {|method| result = instance.send method, args}
    result
  end

  def has_switch args
    args[0][0] == '-'
  end

  def get_switch args
    args[0][1].to_sym
  end
end

module SwitchSupport
  def process args
    code = args[0][1].to_sym
    block = self.class.all_switches[code]
    block.call
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

    def switch code, &block
      all_switches[code] = block
    end
  end
end
