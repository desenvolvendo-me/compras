class Material < ActiveRecord::Base
  attr_accessible :materials_group_id, :materials_class_id, :code, :name, :description, :minimum_stock_balance,
                  :reference_unit_id, :manufacturer, :perishable, :storable, :combustible,
                  :material_characteristic, :service_type_id, :material_type, :stn_ordinance, :expense_element

  attr_protected :stock_balance, :unit_price, :cash_balance, :materials_group, :materials_class, :reference_unit, :service_type

  attr_modal :name

  belongs_to :materials_group
  belongs_to :materials_class
  belongs_to :reference_unit
  belongs_to :service_type

  orderize
  filterize

  validates :materials_group_id, :materials_class_id, :code, :name, :reference_unit_id, :service_type_id, :material_characteristic, :material_type, :presence => true
  validates :code, :name, :uniqueness => true

  has_enumeration_for :material_characteristic, :create_helpers => true
  has_enumeration_for :material_type, :create_helpers => true

  def to_s
    "#{code} - #{name}"
  end
end
