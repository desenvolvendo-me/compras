class ObjectAnnulment
  def self.annul!(object)
    return false if object.annul.present?

    object.annul!
  end
end
