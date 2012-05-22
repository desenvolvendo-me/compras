class SubpledgeExpirationMovimentation < ActiveRecord::Base
  attr_accessible :subpledge_expiration_id, :subpledge_expiration_modificator_type
  attr_accessible :subpledge_expiration_modificator_id, :subpledge_expiration_value_was
  attr_accessible :subpledge_expiration_value, :value

  belongs_to :subpledge_expiration
  belongs_to :subpledge_expiration_modificator, :polymorphic => true

  validates :subpledge_expiration, :subpledge_expiration_modificator, :presence => true
  validates :subpledge_expiration_value_was, :subpledge_expiration_value, :presence => true
  validates :value, :presence => true
end
