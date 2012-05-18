class PledgeParcelMovimentationGenerator
  attr_accessor :pledge_cancellation_object
  attr_accessor :pledge_parcel_movimentation_storage

  delegate :value, :pledge, :to => :pledge_cancellation_object

  def initialize(pledge_cancellation_object, pledge_parcel_movimentation_storage = PledgeParcelMovimentation)
    self.pledge_parcel_movimentation_storage = pledge_parcel_movimentation_storage
    self.pledge_cancellation_object = pledge_cancellation_object
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
    case pledge_cancellation_object.class.name
    when 'PledgeCancellation', 'PledgeLiquidation'
      'balance'
    when 'PledgeLiquidationCancellation'
      'liquidation'
    end
  end

  def create!(parcel, calculator)
    pledge_parcel_movimentation_storage.create!(
      :pledge_parcel_id => parcel.id,
      :pledge_parcel_modificator_id => pledge_cancellation_object.id,
      :pledge_parcel_modificator_type => pledge_cancellation_object.class.name,
      :pledge_parcel_value_was => parcel_value(parcel),
      :pledge_parcel_value => calculator.parcel_value,
      :value => calculator.movimented_value
    )
  end
end
