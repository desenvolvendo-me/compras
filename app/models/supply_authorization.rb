class SupplyAuthorization < ActiveRecord::Base
  attr_accessible :year, :code, :direct_purchase_id

  belongs_to :direct_purchase

  delegate :phone, :fax, :address, :city, :zip_code, :to => :direct_purchase, :allow_nil => true
  delegate :bank_account, :agency, :bank, :provider, :to => :direct_purchase, :allow_nil => true
  delegate :period, :period_unit, :period_unit_humanize, :licitation_object, :observation, :payment_method, :to => :direct_purchase, :allow_nil => true
  delegate :date, :budget_unit, :delivery_location, :to => :direct_purchase, :allow_nil => true

  validates :year, :direct_purchase, :presence => true
  validates :year, :mask => '9999', :allow_blank => true

  before_create :set_code

  orderize :year
  filterize

  def to_s
    "#{code}/#{year}"
  end

  def pluralized_period_unit
    return unless direct_purchase.present?

    if period > 1
      I18n.t("enumerations.period_unit_plural.#{period_unit}")
    else
      period_unit_humanize
    end
  end

  def items_count
    direct_purchase.direct_purchase_budget_allocations.map(&:items).flatten.count
  end

  protected

  def set_code
    last = self.class.where(:year => year).last

    if last
      self.code = last.code.succ
    else
      self.code = 1
    end
  end
end
