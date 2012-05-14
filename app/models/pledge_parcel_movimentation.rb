class PledgeParcelMovimentation < ActiveRecord::Base
  attr_accessible :pledge_parcel_id, :pledge_parcel_modificator_type
  attr_accessible :pledge_parcel_modificator_id, :pledge_parcel_value_was
  attr_accessible :pledge_parcel_value, :value

  belongs_to :pledge_parcel
  belongs_to :pledge_parcel_modificator, :polymorphic => true

  validates :pledge_parcel, :pledge_parcel_modificator, :presence => true
  validates :pledge_parcel_value_was, :pledge_parcel_value, :presence => true
  validates :value, :presence => true
end
