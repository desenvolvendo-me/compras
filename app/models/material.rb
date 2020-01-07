class Material < Unico::Model
  include BelongsToResource

  attr_accessible :code, :material_class_id, :description, :detailed_description,
                  :reference_unit_id, :manufacturer, :material_classification, :combustible,
                  :expense_nature_id, :active, :control_amount, :medicine

  attr_writer :autocomplete_material_class

  attr_modal :description, :material_classification
  has_enumeration_for :material_classification, :with => MaterialClassification, :create_helpers => true

  belongs_to :material_class
  belongs_to :reference_unit

  validates :description,
            :reference_unit,
            :detailed_description,
            :material_classification,:presence => true

  after_validation :set_code

  # has_many :purchase_process_items, :dependent => :restrict
  has_many :purchase_solicitation_items, :dependent => :restrict
  # has_many :price_collection_items, :dependent => :restrict
  # has_many :creditor_materials, :dependent => :restrict
  has_many :purchase_solicitations, :through => :purchase_solicitation_items, :dependent => :restrict
  # has_many :purchase_solicitation_budget_allocations, :through => :purchase_solicitations, :dependent => :restrict
  # has_many :materials_controls, :dependent => :destroy, :inverse_of => :material, :order => :id
  # has_many :licitation_processeslicitation_processes, through: :purchase_process_items

  # validates :material_class, :reference_unit, :material_type, :detailed_description, :presence => true
  # validates :code, :description, :presence => true, :uniqueness => { :allow_blank => true }
  # validates :control_amount, :inclusion => { :in => [true, false] }

  orderize :description
  filterize

  has_many :items, class_name: 'PurchaseProcessItem'

  scope :by_licitation_process, lambda {|licitation_process_id|
    joins(items: [:licitation_process]).where("compras_licitation_processes.id = ?", licitation_process_id)
  }

  scope :by_material_type, lambda { |material_type|
    where { |material| material.material_type.eq(material_type) }
  }

  scope :term, lambda { |q|
    where { code.like("#{q}%") | description.like("#{q}%") }
  }

  scope :by_licitation_process_status, ->(status) do
    joins(items: [:licitation_process]).where("compras_licitation_processes.status = '#{status}'").uniq
  end

  scope :by_material_class_id, ->(material_class_id) do
    where { |query| query.material_class_id.eq(material_class_id) }
  end

  scope :by_pending_purchase_solicitation_budget_structure_id, ->(budget_structure_id) do
    joins { purchase_solicitation_items.purchase_solicitation }.
    where {
      purchase_solicitation_items.purchase_solicitation.budget_structure_id.eq(budget_structure_id) &
      purchase_solicitation_items.purchase_solicitation.service_status.eq(PurchaseSolicitationServiceStatus::PENDING)
    }
  end

  scope :not_purchase_solicitation, ->(purchase_solicitation_id) do
    joins { purchase_solicitation_items }.
    where {
      purchase_solicitation_items.purchase_solicitation_id.not_eq(purchase_solicitation_id)
    }
  end

  def set_code
    self.code = Material.last.nil? ? "1": (Material.last.id+1)
  end

  def to_s
    "#{code} - #{description}"
  end

  def autocomplete_material_class
    return '' unless material_class.present?

    material_class.to_s
  end

  def service_without_quantity?
    service? && !control_amount?
  end
end
