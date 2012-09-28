class SupplyAuthorization < Compras::Model
  include Signable

  attr_accessible :year, :direct_purchase_id

  attr_readonly :code

  auto_increment :code, :by => :year

  belongs_to :direct_purchase

  delegate :phone, :fax, :address, :city, :zip_code, :accounts, :agencies,
           :banks, :creditor, :date, :budget_structure, :delivery_location,
           :delivery_term, :delivery_term_period, :delivery_term_period_humanize,
           :licitation_object, :observation, :payment_method, :annulled?,
           :to => :direct_purchase, :allow_nil => true
  delegate :id, :year, :to => :direct_purchase, :prefix => true, :allow_nil => true

  validates :year, :direct_purchase, :presence => true
  validates :year, :mask => '9999', :allow_blank => true

  orderize :year
  filterize

  def to_s
    "#{code}/#{year}"
  end

  def items_count
    direct_purchase.direct_purchase_budget_allocations.map(&:items).flatten.count
  end
end
