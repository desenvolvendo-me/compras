class ObjectAnnulment
  def initialize(object)
    @object = object
  end

  def annul!
    return false if  @object.annul.present?

    @object.annul!
  end
end
