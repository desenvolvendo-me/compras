class ReserveFundAnnul < Compras::Model
  attr_accessible :employee_id, :date, :reserve_fund_id

  belongs_to :reserve_fund
  belongs_to :employee

  validates :reserve_fund, :employee, :date, :presence => true
end
