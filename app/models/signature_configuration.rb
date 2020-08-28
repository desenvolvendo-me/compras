class SignatureConfiguration < Compras::Model
  attr_accessible :report, :signature_configuration_items_attributes

  attr_modal :report

  has_enumeration_for :report, :with => SignatureReport

  has_many :signature_configuration_items, :dependent => :destroy, :order => :order

  accepts_nested_attributes_for :signature_configuration_items, :allow_destroy => true

  validates :report, :presence => true
  validates :report, :uniqueness => true, :allow_blank => true
  validates :signature_configuration_items, :no_duplication => :order
  validates :signature_configuration_items, :no_duplication => :signature_id

  def self.unavailables_reports
    select('distinct report').pluck(:report)
  end

  orderize "id DESC"
  filterize

  def to_s
    report_humanize
  end
end
