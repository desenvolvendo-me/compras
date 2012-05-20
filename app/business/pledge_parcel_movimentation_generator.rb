class PledgeParcelMovimentationGenerator
  attr_accessor :object
  attr_accessor :pledge_parcel_movimentation_storage

  delegate :value, :pledge, :to => :object

  def initialize(object, pledge_parcel_movimentation_storage = PledgeParcelMovimentation)
    self.pledge_parcel_movimentation_storage = pledge_parcel_movimentation_storage
    self.object = object
  end

  def generate!
    value_left = value

    pledge_parcels.each do |parcel|
      return if value_left.zero?

      calculator = PledgeParcelMovimentationCalculator.new(value_left, parcel_value(parcel))

      create!(parcel, calculator)

      value_left -= calculator.movimented_value
    end
  end

  protected

  def parcel_value(parcel)
    case kind
    when 'balance'
      parcel.balance
    when 'liquidation'
      parcel.liquidations_value
    end
  end

  def pledge_parcels
    case kind
    when 'balance'
      pledge.pledge_parcels_with_balance
    when 'liquidation'
      pledge.pledge_parcels_with_liquidations
    end
  end

  def kind
    case object.class.name
    when 'PledgeCancellation', 'PledgeLiquidation', 'Subpledge'
      'balance'
    when 'PledgeLiquidationCancellation'
      'liquidation'
    end
  end

  def create!(parcel, calculator)
    pledge_parcel_movimentation_storage.create!(
      :pledge_parcel_id => parcel.id,
      :pledge_parcel_modificator_id => object.id,
      :pledge_parcel_modificator_type => object.class.name,
      :pledge_parcel_value_was => parcel_value(parcel),
      :pledge_parcel_value => calculator.parcel_value,
      :value => calculator.movimented_value
    )
  end
end
