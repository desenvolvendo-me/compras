class AuctionSupportTeam < Compras::Model
  attr_accessible :auction_id, :employee_id

  belongs_to :auction
  belongs_to :employee
end
