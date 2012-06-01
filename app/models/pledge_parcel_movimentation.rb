class PledgeParcelMovimentation < ActiveRecord::Base
  attr_accessible :pledge_parcel_id, :pledge_parcel_modifiable_type
  attr_accessible :pledge_parcel_modifiable_id, :pledge_parcel_value_was
  attr_accessible :pledge_parcel_value, :value

  belongs_to :pledge_parcel
  belongs_to :pledge_parcel_modifiable, :polymorphic => true

  validates :pledge_parcel, :pledge_parcel_modifiable, :presence => true
  validates :pledge_parcel_value_was, :pledge_parcel_value, :presence => true
  validates :value, :presence => true
end
