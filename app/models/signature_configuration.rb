class SignatureConfiguration < Compras::Model
  attr_accessible :report, :signature_configuration_items_attributes

  has_enumeration_for :report, :with => SignatureReport

  has_many :signature_configuration_items, :dependent => :destroy, :order => :order

  accepts_nested_attributes_for :signature_configuration_items, :allow_destroy => true

  validates :report, :presence => true
  validates :report, :uniqueness => true, :allow_blank => true
  validate :cannot_have_duplicated_order
  validate :cannot_have_duplicated_signature

  def self.unavailables_reports
    select('distinct report').pluck(:report)
  end

  orderize :id
  filterize

  def to_s
    report_humanize
  end

  def cannot_have_duplicated_order
   single_orders = []

   signature_configuration_items.reject(&:marked_for_destruction?).each do |item|
     if single_orders.include?(item.order)
       errors.add(:signature_configuration_items)
       item.errors.add(:order, :taken)
     end
     single_orders << item.order
   end
  end

  def cannot_have_duplicated_signature
   single_signatures = []

   signature_configuration_items.reject(&:marked_for_destruction?).each do |item|
     if single_signatures.include?(item.signature)
       errors.add(:signature_configuration_items)
       item.errors.add(:signature, :taken)
     end
     single_signatures << item.signature
   end
  end

end
