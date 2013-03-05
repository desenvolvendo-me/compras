class Material < Compras::Model
  attr_accessible :materials_class_id, :code, :material_type, :manufacturer,
                  :detailed_description, :minimum_stock_balance, :combustible,
                  :reference_unit_id, :material_characteristic, :perishable,
                  :contract_type_id, :expense_nature_id, :description,
                  :storable, :autocomplete_materials_class

  attr_writer :autocomplete_materials_class

  attr_modal :description, :material_characteristic

  has_enumeration_for :material_characteristic, :create_helpers => true
  has_enumeration_for :material_type, :create_helpers => true

  belongs_to :materials_class
  belongs_to :reference_unit
  belongs_to :contract_type
  belongs_to :expense_nature

  has_and_belongs_to_many :licitation_objects, :join_table => :compras_licitation_objects_compras_materials

  has_many :direct_purchase_budget_allocation_items, :dependent => :restrict
  has_many :administrative_process_budget_allocation_items, :dependent => :restrict
  has_many :purchase_solicitation_budget_allocation_items, :dependent => :restrict
  has_many :price_collection_lot_items, :dependent => :restrict
  has_many :creditor_materials, :dependent => :restrict
  has_many :purchase_solicitation_item_group_materials, :dependent => :destroy
  has_many :purchase_solicitation_budget_allocations, :through => :purchase_solicitation_budget_allocation_items, :dependent => :restrict

  validates :materials_class, :reference_unit, :presence => true
  validates :material_characteristic, :presence => true
  validates :code, :description, :presence => true, :uniqueness => { :allow_blank => true }
  validates :material_type, :presence => true, :if => :material?
  validates :contract_type, :presence => true, :if => :service?

  before_save :clean_unnecessary_type

  before_destroy :validate_licitation_object_relationship

  orderize :description
  filterize

  scope :licitation_object_id, lambda { |licitation_object_id|
    joins(:licitation_objects).where { licitation_objects.id.eq(licitation_object_id) }
  }

  def self.last_by_materials_class_and_group(params = {})
    record = scoped
    record = record.where { materials_class_id.eq(params.fetch(:materials_class_id)) }
    record = record.order { code }.last
    record
  end

  def self.by_characteristic(characteristic)
    where { material_characteristic.eq characteristic }
  end

  def self.by_pending_purchase_solicitation_budget_structure_id(budget_structure_id)
    joins { purchase_solicitation_budget_allocation_items }.
    joins { purchase_solicitation_budget_allocations.purchase_solicitation }.
    where do
      purchase_solicitation_budget_allocations.purchase_solicitation.budget_structure_id.eq(budget_structure_id) &
      purchase_solicitation_budget_allocations.purchase_solicitation.service_status.eq(PurchaseSolicitationServiceStatus::PENDING)
    end
  end

  def self.not_purchase_solicitation(purchase_solicitation_id)
    joins { purchase_solicitation_budget_allocation_items }.
    joins { purchase_solicitation_budget_allocations }.
    where do
      purchase_solicitation_budget_allocations.purchase_solicitation_id.not_eq(purchase_solicitation_id)
    end
  end

  def to_s
    "#{code} - #{description}"
  end

  def autocomplete_materials_class
    return '' unless materials_class.present?

    materials_class.to_s
  end

  protected

  def clean_unnecessary_type
    if material?
      self.contract_type_id = nil
    elsif service?
      self.material_type = nil
    end
  end

  def validate_licitation_object_relationship
    return unless licitation_objects.any?

    errors.add(:base, :cant_be_destroyed)

    false
  end
end
