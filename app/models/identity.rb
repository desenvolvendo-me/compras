class Identity < Persona::Identity

  validates :number, presence: true

  def to_s
    number.to_s
  end
end
