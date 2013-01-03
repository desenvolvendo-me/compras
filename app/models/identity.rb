class Identity < Persona::Identity
  def to_s
    number.to_s
  end
end
