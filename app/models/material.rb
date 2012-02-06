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

  validates :materials_group_id, :materials_class_id, :code, :name, :reference_unit_id, :material_characteristic, :presence => true
  validates :code, :name, :uniqueness => true
  validates :material_type, :presence => true, :if => :material?
  validates :service_or_contract_type, :presence => true, :if => :service?

  has_enumeration_for :material_characteristic, :create_helpers => true
  has_enumeration_for :material_type, :create_helpers => true

  before_save :clean_unnecessary_type

  def to_s
    "#{code} - #{name}"
  end

  protected

  def clean_unnecessary_type
    if self.material_characteristic == MaterialCharacteristic::MATERIAL
      self.service_or_contract_type_id = nil
    elsif material_characteristic == MaterialCharacteristic::SERVICE
      self.material_type = nil
    end
  end
end
