class ObjectAnnulment
  def initialize(object)
    @object = object
  end

  def annul!
    return false unless @object.annul.present?

    @object.annul!
  end
end
