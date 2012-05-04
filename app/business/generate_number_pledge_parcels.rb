class GenerateNumberPledgeParcels
  attr_accessor :pledge_parcels

  def initialize(pledge_parcels)
    self.pledge_parcels = pledge_parcels
  end

  def generate!
    pledge_parcels.each_with_index do |parcel, index|
      parcel.number = index.succ
    end
  end
end
