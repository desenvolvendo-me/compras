class ProviderPartner < ActiveRecord::Base
  attr_accessible :provider_id, :individual_id, :function, :date

  has_enumeration_for :function, :create_helpers => true, :with => ProviderPartnerFunction

  belongs_to :provider
  belongs_to :individual

  validates :individual_id, :function, :date, :presence => true
end
