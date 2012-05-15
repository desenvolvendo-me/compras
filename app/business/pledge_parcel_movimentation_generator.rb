class PledgeParcelMovimentationGenerator
  attr_accessor :pledge_cancellation_object
  attr_accessor :pledge_parcel_movimentation_storage

  delegate :pledge, :to => :pledge_cancellation_object
  delegate :pledge_parcels_with_balance, :to => :pledge
  delegate :value, :to => :pledge_cancellation_object

  def initialize(pledge_cancellation_object, pledge_parcel_movimentation_storage = PledgeParcelMovimentation)
    self.pledge_parcel_movimentation_storage = pledge_parcel_movimentation_storage
    self.pledge_cancellation_object = pledge_cancellation_object
  end

  def generate!
    value_left = value

    pledge_parcels_with_balance.each do |parcel|
      return if value_left.zero?

      calculator = PledgeParcelMovimentationCalculator.new(value_left, parcel.balance)

      create!(parcel, pledge_cancellation_object, calculator)

      value_left -= calculator.movimented_value
    end
  end

  protected

  def create!(parcel, pledge_cancellation_object, calculator)
    pledge_parcel_movimentation_storage.create!(
      :pledge_parcel_id => parcel.id,
      :pledge_parcel_modificator_id => pledge_cancellation_object.id,
      :pledge_parcel_modificator_type => pledge_cancellation_object.class.name,
      :pledge_parcel_value_was => parcel.balance,
      :pledge_parcel_value => calculator.parcel_value,
      :value => calculator.movimented_value
    )
  end
end
