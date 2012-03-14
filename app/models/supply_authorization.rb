class SupplyAuthorization < ActiveRecord::Base
  attr_accessible :year, :code, :direct_purchase_id

  belongs_to :direct_purchase

  validates :year, :direct_purchase, :presence => true
  validates :year, :mask => '9999'

  orderize :year
  filterize

  def to_s
    "#{code}/#{year}"
  end

  before_create :set_code

  def items_count
    direct_purchase.direct_purchase_budget_allocations.map(&:items).flatten.count
  end

  protected

  def set_code
    last = self.class.where(:year => year).last

    if last
      self.code = last.code.to_i + 1
    else
      self.code = 1
    end
  end
end
