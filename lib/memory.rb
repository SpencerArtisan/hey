require 'persistable'

class Memory
  include Persistable

  attr_accessor :description, :state, :priority, :group, :appear_on, :completed_on_s
  defaults state: 'Not started', priority: 'Medium'

  def complete
    update state: 'complete', completed_on_s: Time.now.to_i
  end

  def completed_on= value
    completed_on_s = value == nil ? nil : value.to_i
  end

  def completed_on
    completed_on_s == nil ? nil : Time.at(completed_on_s.to_i)
  end
end
