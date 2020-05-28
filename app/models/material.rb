class Material < Unico::Model
  include BelongsToResource

  default_scope where(origin_source: "compras")

  attr_accessible :code, :material_class_id, :description, :detailed_description,
                  :reference_unit_id, :manufacturer, :material_classification,
                  :combustible,:expense_nature_id, :active, :control_amount,
                  :medicine,:origin_source,:quantity_unit,:split_expense_id

  attr_writer :autocomplete_material_class

  attr_modal :description, :material_classification
  has_enumeration_for :material_classification, :with => MaterialClassification, :create_helpers => true
  has_enumeration_for :origin_source, :with => MaterialOriginSource, :create_helpers => true

  belongs_to :split_expense
  belongs_to :material_class
  belongs_to :reference_unit
  has_many :purchase_process_items

  validates :description,
            :reference_unit,
            :detailed_description,
            :material_classification, :presence => true

  after_validation :set_code
  before_create :origin_source_default

  has_many :purchase_process_items, :dependent => :restrict
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

  scope :material_of_supply_request, lambda {|params|
    lpr = LicitationProcessRatification.joins("inner join compras_supply_requests on compras_supply_requests.creditor_id = compras_licitation_process_ratifications.creditor_id").where(licitation_process_id:params.split(',')[0],compras_supply_requests:{contract_id:params.split(',')[1]}).pluck(:id).uniq
    sql =	"select material_id from public.compras_licitation_process_ratification_items ri inner join public.compras_realignment_price_items pi on ri.realignment_price_item_id = pi.id inner join public.compras_purchase_process_items cpi on cpi.id = ri.purchase_process_item_id where ri.licitation_process_ratification_id in (#{lpr.join(',')});"
    records_array = ActiveRecord::Base.connection.execute(sql)
    material_ids = []
    records_array.ntuples.times { |index| material_ids << records_array[index]['material_id'] }

    where { id.in material_ids }
  }

  scope :by_licitation_process, lambda {|licitation_process_id|
    joins(items: [:licitation_process]).where("compras_licitation_processes.id = ?", licitation_process_id)
  }

  scope :by_material_type, lambda {|material_type|
    where {|material| material.material_type.eq(material_type)}
  }

  scope :term, lambda {|q|
    where {code.like("#{q}%") | description.like("#{q}%")}
  }

  has_many :items_supply_orders, class_name: 'SupplyOrderItem'

  scope :by_supply_order, lambda {|supply_order_id|
    joins(items_supply_orders: [:supply_order]).
        where("compras_supply_orders.id in (#{supply_order_id})")
  }

  scope :by_licitation_process_status, ->(status) do
    joins(items: [:licitation_process]).where("compras_licitation_processes.status = '#{status}'").uniq
  end

  scope :by_material_class_id, ->(material_class_id) do
    where {|query| query.material_class_id.eq(material_class_id)}
  end

  scope :by_pending_purchase_solicitation_budget_structure_id, ->(budget_structure_id) do
    joins {purchase_solicitation_items.purchase_solicitation}.
        where {
          purchase_solicitation_items.purchase_solicitation.budget_structure_id.eq(budget_structure_id) &
              purchase_solicitation_items.purchase_solicitation.service_status.eq(PurchaseSolicitationServiceStatus::PENDING)
        }
  end

  scope :not_purchase_solicitation, ->(purchase_solicitation_id) do
    joins {purchase_solicitation_items}.
        where {
          purchase_solicitation_items.purchase_solicitation_id.not_eq(purchase_solicitation_id)
        }
  end

  def set_code
    self.code = Material.unscoped.last.nil? ? "1" : (Material.unscoped.last.id + 1)
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

  def origin_source_default
    self.origin_source = MaterialOriginSource::COMPRAS
  end
end
