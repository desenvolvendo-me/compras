class PledgeRequestPurchaseSolicitation < Compras::Model
  belongs_to :pledge_request
  belongs_to :purchase_solicitation

  attr_accessible :purchase_solicitation_id

  # scope :pledge_request_id, lambda { |pledge_request_id| joins(:pledge_requests).where { pledge_requests.id.eq(pledge_request_id) } }
  # scope :purchase_solicitation_id, lambda { |id| where { purchase_solicitation_id.eq(id) } }

  filterize
  orderize

end
