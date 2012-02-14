class Material < ActiveRecord::Base
  attr_accessible :materials_class_id, :code, :description, :detailed_description, :minimum_stock_balance,
                  :reference_unit_id, :manufacturer, :perishable, :storable, :combustible,
                  :material_characteristic, :service_or_contract_type_id, :material_type,
                  :economic_classification_of_expenditure_id

  attr_protected :stock_balance, :unit_price, :cash_balance, :materials_group, :materials_group_id, :materials_class,
                 :reference_unit, :service_or_contract_type, :economic_classification_of_expenditure,
                 :stn_ordinance, :stn_ordinance_id

  attr_modal :description

  delegate :materials_group, :materials_group_id, :to => :materials_class, :allow_nil => true
  delegate :stn_ordinance, :stn_ordinance_id, :to => :economic_classification_of_expenditure, :allow_nil => true

  belongs_to :materials_group
  belongs_to :materials_class
  belongs_to :reference_unit
  belongs_to :stn_ordinance
  belongs_to :service_or_contract_type
  belongs_to :economic_classification_of_expenditure
  has_many :purchase_solicitation_items, :dependent => :restrict

  orderize :description
  filterize

  validates :materials_group_id, :materials_class_id, :reference_unit_id, :material_characteristic, :presence => true
  validates :economic_classification_of_expenditure_id, :presence => true
  validates :code, :presence => true, :uniqueness => true
  validates :description, :presence => true, :uniqueness => true
  validates :material_type, :presence => true, :if => :material?
  validates :service_or_contract_type, :presence => true, :if => :service?
  validate  :class_must_belong_to_group

  has_enumeration_for :material_characteristic, :create_helpers => true
  has_enumeration_for :material_type, :create_helpers => true

  before_save :clean_unnecessary_type

  def to_s
    "#{code} - #{description}"
  end

  def self.last_by_materials_class_and_group(params = {})
    record = scoped
    record = record.where { materials_class_id.eq(params.fetch(:materials_class_id)) }
    record = record.order { code }.last
    record
  end

  protected

  def clean_unnecessary_type
    if material?
      self.service_or_contract_type_id = nil
    elsif service?
      self.material_type = nil
    end
  end

  def class_must_belong_to_group
    if materials_class && materials_class.materials_group_id != materials_group_id
      errors.add(:materials_class_id, :materials_class_must_belong_to_group)
    end
  end
end
