class Material < ActiveRecord::Base
  attr_accessible :materials_group_id, :materials_class_id, :code, :name, :description, :minimum_stock_balance,
                  :reference_unit_id, :manufacturer, :perishable, :storable, :combustible,
                  :material_characteristic, :service_or_contract_type_id, :material_type, :stn_ordinance, :expense_element

  attr_protected :stock_balance, :unit_price, :cash_balance, :materials_group, :materials_class, :reference_unit, :service_or_contract_type

  attr_modal :name

  belongs_to :materials_group
  belongs_to :materials_class
  belongs_to :reference_unit
  belongs_to :service_or_contract_type
  has_many :purchase_solicitation_items

  orderize
  filterize

  validates :materials_group_id, :materials_class_id, :reference_unit_id, :material_characteristic, :presence => true
  validates :code, :presence => true, :uniqueness => true, :numericality => true
  validates :name, :presence => true, :uniqueness => true
  validates :material_type, :presence => true, :if => :material?
  validates :service_or_contract_type, :presence => true, :if => :service?
  validate  :class_must_belong_to_group

  has_enumeration_for :material_characteristic, :create_helpers => true
  has_enumeration_for :material_type, :create_helpers => true

  before_save :clean_unnecessary_type

  def to_s
    "#{code} - #{name}"
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
