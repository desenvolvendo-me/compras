class PledgeParcelMovimentationGenerator
  attr_accessor :object
  attr_accessor :pledge_parcel_movimentation_storage

  delegate :value, :pledge, :movimentable_pledge_parcels, :to => :object

  def initialize(object, pledge_parcel_movimentation_storage = PledgeParcelMovimentation)
    self.pledge_parcel_movimentation_storage = pledge_parcel_movimentation_storage
    self.object = object
  end

  def generate!
    value_left = value

    movimentable_pledge_parcels.each do |parcel|
      return if value_left.zero?

      calculator = PledgeParcelMovimentationCalculator.new(value_left, value_by_modificator_type(parcel))

      create!(parcel, calculator)

      value_left -= calculator.movimented_value
    end
  end

  protected

  def value_by_modificator_type(parcel)
    if object.class.name == 'PledgeLiquidationCancellation'
      parcel.liquidations_value
    else
      parcel.balance
    end
  end

  def create!(parcel, calculator)
    pledge_parcel_movimentation_storage.create!(
      :pledge_parcel_id => parcel.id,
      :pledge_parcel_modificator_id => object.id,
      :pledge_parcel_modificator_type => object.class.name,
      :pledge_parcel_value_was => value_by_modificator_type(parcel),
      :pledge_parcel_value => calculator.parcel_value,
      :value => calculator.movimented_value
    )
  end
end
