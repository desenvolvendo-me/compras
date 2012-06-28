class ReserveFundAnnul < Compras::Model
  include Annullable

  attr_accessible :reserve_fund_id

  belongs_to :reserve_fund
  belongs_to :employee

  validates :reserve_fund, :presence => true
end
