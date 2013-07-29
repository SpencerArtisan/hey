class Switch < BasicObject
  def method_missing m, *args
    @switch_methods ||= {}
    @switch_methods[m] = args
  end

  def no_args *methods
    @no_args = methods
  end

  def default *methods
    @default = methods
  end

  def handle_switch instance, args
    methods = 
      if args.length == 0
        @no_args
      elsif has_switch(args)
        @switch_methods[get_switch(args)]
      else
        @default
      end
    result = nil
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
  def switches args
    self.class.switches.handle_switch self, args
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
  end
end
