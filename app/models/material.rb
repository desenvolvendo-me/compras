class Material < Compras::Model
  include BelongsToResource

  attr_accessible :code, :material_class_id, :description, :detailed_description,
                  :reference_unit_id, :manufacturer, :material_type, :combustible,
                  :expense_nature_id, :active, :control_amount

  attr_writer :autocomplete_material_class

  attr_modal :description, :material_type

  has_enumeration_for :material_type, :with => UnicoAPI::Resources::Compras::Enumerations::MaterialType,
                      :create_helpers => true, :create_scopes => true

  belongs_to :material_class
  belongs_to :reference_unit

  belongs_to_resource :expense_nature

  has_many :purchase_process_items, :dependent => :restrict
  has_many :purchase_solicitation_items, :dependent => :restrict
  has_many :price_collection_lot_items, :dependent => :restrict
  has_many :creditor_materials, :dependent => :restrict
  has_many :purchase_solicitations, :through => :purchase_solicitation_items, :dependent => :restrict
  has_many :purchase_solicitation_budget_allocations, :through => :purchase_solicitations, :dependent => :restrict
  has_many :materials_controls, :dependent => :destroy, :inverse_of => :material, :order => :id

  validates :material_class, :reference_unit, :material_type, :detailed_description, :presence => true
  validates :code, :description, :presence => true, :uniqueness => { :allow_blank => true }
  validates :control_amount, :inclusion => { :in => [true, false] }

  orderize :description
  filterize

  scope :by_material_type, lambda { |material_type|
    where { |material| material.material_type.eq(material_type) }
  }

  scope :term, lambda { |q|
    where { code.like("#{q}%") | description.like("#{q}%") }
  }

  def self.last_by_material_class_and_group(params = {})
    record = scoped
    record = record.where { material_class_id.eq(params.fetch(:material_class_id)) }
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

  def autocomplete_material_class
    return '' unless material_class.present?

    material_class.to_s
  end
end
