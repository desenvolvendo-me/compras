class ValueForcer

  attr_accessor :object, :attr_name, :forced_value
  def initialize(object, attr_name)
    self.object       = object
    self.attr_name    = attr_name.to_s
    self.forced_value = object.send("forced_#{attr_name}")
  end

  #
  # Exmaples:
  # ValueForcer.new(agreement, :initial_value).force!
  #
  # if agreement.forced_initial_value.present?
  #   agreement.initial_value = agreement.forced_initial_value
  # else
  #   agreement.initial_value don't change
  # end
  #
  def force!
    if forced_value.present?
      object.send("#{attr_name}=", forced_value)
    end
  end
end
