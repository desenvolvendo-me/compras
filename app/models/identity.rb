class Identity < Persona::Identity
  validates :issuer, :state, :issue, :presence => true

  def to_s
    number.to_s
  end
end
