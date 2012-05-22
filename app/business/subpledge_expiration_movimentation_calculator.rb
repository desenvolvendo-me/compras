class SubpledgeExpirationMovimentationCalculator
  attr_accessor :moviment_value, :expiration_balance

  def initialize(moviment_value, expiration_balance)
    self.moviment_value = moviment_value
    self.expiration_balance = expiration_balance
  end

  def expiration_value
    expiration_balance - movimented_value
  end

  def movimented_value
    if moviment_value >= expiration_balance
      expiration_balance
    else
      moviment_value
    end
  end
end
