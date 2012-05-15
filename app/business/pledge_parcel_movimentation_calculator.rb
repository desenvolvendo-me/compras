class PledgeParcelMovimentationCalculator
  attr_accessor :moviment_value, :parcel_balance

  def initialize(moviment_value, parcel_balance)
    self.moviment_value = moviment_value
    self.parcel_balance = parcel_balance
  end

  def parcel_value
    parcel_balance - movimented_value
  end

  def movimented_value
    if moviment_value >= parcel_balance
      parcel_balance
    else
      moviment_value
    end
  end
end
