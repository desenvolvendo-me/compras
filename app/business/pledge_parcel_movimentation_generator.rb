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
      if value_left.zero?
        return
      else
        if value_left >= parcel.balance
          current_value = parcel.balance
        else
          current_value = value_left
        end

        pledge_parcel_movimentation_storage.create!(
          :pledge_parcel_id => parcel.id,
          :pledge_parcel_modificator_id => pledge_cancellation_object.id,
          :pledge_parcel_modificator_type => pledge_cancellation_object.class.name,
          :pledge_parcel_value_was => parcel.balance,
          :pledge_parcel_value => parcel.balance - current_value,
          :value => current_value
        )

        value_left -= current_value
      end
    end
  end
end
