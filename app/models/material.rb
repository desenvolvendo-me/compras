class Material < Compras::Model
  attr_accessible :code, :materials_class_id, :description, :detailed_description,
                  :reference_unit_id, :manufacturer, :material_type, :combustible,
                  :expense_nature_id, :contract_type_id, :active, :control_amount

  attr_writer :autocomplete_materials_class

  attr_modal :description, :material_type

  has_enumeration_for :material_type, :create_helpers => true, :create_scopes => true

  belongs_to :materials_class
  belongs_to :reference_unit
  belongs_to :contract_type
  belongs_to :expense_nature

  has_and_belongs_to_many :licitation_objects, :join_table => :compras_licitation_objects_compras_materials

  has_many :direct_purchase_budget_allocation_items, :dependent => :restrict
  has_many :administrative_process_budget_allocation_items, :dependent => :restrict
  has_many :purchase_solicitation_items, :dependent => :restrict
  has_many :price_collection_lot_items, :dependent => :restrict
  has_many :creditor_materials, :dependent => :restrict
  has_many :purchase_solicitations, :through => :purchase_solicitation_items, :dependent => :restrict
  has_many :purchase_solicitation_budget_allocations, :through => :purchase_solicitations, :dependent => :restrict
  has_many :materials_controls, :dependent => :destroy, :inverse_of => :material, :order => :id

  validates :materials_class, :reference_unit, :material_type, :detailed_description, :presence => true
  validates :code, :description, :presence => true, :uniqueness => { :allow_blank => true }
  validates :contract_type, :presence => true, :if => :service?
  validates :control_amount, :inclusion => { :in => [true, false] }

  before_save :clean_unnecessary_type

  before_destroy :validate_licitation_object_relationship

  orderize :description
  filterize

  scope :licitation_object_id, lambda { |licitation_object_id|
    joins(:licitation_objects).where { licitation_objects.id.eq(licitation_object_id) }
  }

  scope :by_material_type, lambda { |material_type|
    where { |material| material.material_type.eq(material_type) }
  }

  def self.last_by_materials_class_and_group(params = {})
    record = scoped
    record = record.where { materials_class_id.eq(params.fetch(:materials_class_id)) }
    record = record.order { code }.last
    record
  end

  def self.by_pending_purchase_solicitation_budget_structure_id(budget_structure_id)
    joins { purchase_solicitation_items.purchase_solicitation }.
    where do
      purchase_solicitation_items.purchase_solicitation.budget_structure_id.eq(budget_structure_id) &
      purchase_solicitation_items.purchase_solicitation.service_status.eq(PurchaseSolicitationServiceStatus::PENDING)
    end
  end

  def self.not_purchase_solicitation(purchase_solicitation_id)
    joins { purchase_solicitation_items }.
    where do
      purchase_solicitation_items.purchase_solicitation_id.not_eq(purchase_solicitation_id)
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
    if consumption? || asset?
      self.contract_type_id = nil
    end
  end

  def validate_licitation_object_relationship
    return unless licitation_objects.any?

    errors.add(:base, :cant_be_destroyed)

    false
  end
end
