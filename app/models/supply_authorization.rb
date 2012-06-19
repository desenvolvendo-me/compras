class SupplyAuthorization < Compras::Model
  attr_accessible :year, :code, :direct_purchase_id

  belongs_to :direct_purchase

  delegate :phone, :fax, :address, :city, :zip_code, :to => :direct_purchase, :allow_nil => true
  delegate :accounts, :agencies, :banks, :creditor, :to => :direct_purchase, :allow_nil => true
  delegate :period, :period_unit, :period_unit_humanize, :licitation_object, :observation, :payment_method, :to => :direct_purchase, :allow_nil => true
  delegate :date, :budget_structure, :delivery_location, :to => :direct_purchase, :allow_nil => true

  validates :year, :direct_purchase, :presence => true
  validates :year, :mask => '9999', :allow_blank => true

  before_create :set_code

  orderize :year
  filterize

  def to_s
    "#{code}/#{year}"
  end

  def items_count
    direct_purchase.direct_purchase_budget_allocations.map(&:items).flatten.count
  end

  def signatures(signature_configuration_item = SignatureConfigurationItem)
    signature_configuration_item.all_by_configuration_report(SignatureReport::SUPPLY_AUTHORIZATIONS)
  end

  def signatures_grouped
    signatures.in_groups_of(4, false)
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
