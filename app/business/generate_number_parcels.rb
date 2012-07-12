class GenerateNumberParcels
  attr_accessor :parcels

  def initialize(parcels)
    self.parcels = parcels
  end

  def generate!
    parcels.each_with_index do |parcel, index|
      parcel.number = index.succ
    end
  end
end
