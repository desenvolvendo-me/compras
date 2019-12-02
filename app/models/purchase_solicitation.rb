class PurchaseSolicitation < Compras::Model
  include BelongsToResource

  attr_accessible :accounting_year, :request_date, :responsible_id, :kind,
                  :delivery_location_id, :general_observations, :justification,
                  :purchase_solicitation_budget_allocations_attributes,
                  :items_attributes, :budget_structure_id,
                  :user_id, :department_id,
                  :purchase_form_id,:attendant_status,:model_request

  attr_readonly :code

  auto_increment :code, :by => :accounting_year

  attr_modal :code, :accounting_year, :kind, :delivery_location_id, :budget_structure_id, :responsible_id

  has_enumeration_for :attendant_status, :with => PurchaseSolicitationAttendantStatus, :create_helpers => true
  has_enumeration_for :kind, :with => PurchaseSolicitationKind, :create_helpers => true
  has_enumeration_for :service_status, :with => PurchaseSolicitationServiceStatus,
                      :create_helpers => true, :create_scopes => true

  belongs_to :purchase_form
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :department, :class_name => 'Department', :foreign_key => 'department_id'
  belongs_to :responsible, :class_name => 'Employee', :foreign_key => 'responsible_id'
  belongs_to :delivery_location
  belongs_to :liberator, :class_name => 'Employee', :foreign_key => 'liberator_id'

  belongs_to_resource :budget_structure

  has_many :items, :class_name => 'PurchaseSolicitationItem', :dependent => :restrict,
           :inverse_of => :purchase_solicitation, :order => :id

  has_and_belongs_to_many :licitation_processes, :join_table => :compras_licitation_processes_purchase_solicitations

  has_many :purchase_solicitation_budget_allocations, :dependent => :destroy,
           :inverse_of => :purchase_solicitation, :order => :id
  has_many :purchase_solicitation_liberations, :dependent => :destroy, :order => :sequence, :inverse_of => :purchase_solicitation

  has_many :price_collection_items, through: :price_collections, source: :items
  has_many :price_collection_proposal_items, through: :price_collection_items
  has_many :list_purchase_solicitations

  has_one :annul, :class_name => 'ResourceAnnul', :as => :annullable, :dependent => :destroy

  has_and_belongs_to_many :price_collections, join_table: :compras_price_collections_purchase_solicitations

  accepts_nested_attributes_for :purchase_solicitation_budget_allocations, :allow_destroy => true
  accepts_nested_attributes_for :items, :allow_destroy => true
  # accepts_nested_attributes_for :purchase_form_items, :allow_destroy => true

  delegate :authorized?, :to => :direct_purchase, :prefix => true, :allow_nil => true

  # validates :request_date, :responsible, :delivery_location, :presence => true
  # validates :accounting_year, :kind, :delivery_location, :presence => true
  # validates :accounting_year, :numericality => true, :mask => '9999', :allow_blank => true
  # validates :purchase_solicitation_budget_allocations, :no_duplication => :budget_allocation_id
  validates :items, :no_duplication => :material_id
  # validate :must_have_at_least_one_item
  # validate :validate_budget_structure_and_materials
  # validate :validate_liberated_status
  validate :items_blank?

  # before_save :set_budget_structure_description

  orderize "id DESC"
  filterize

  scope :by_licitation_process, lambda {|purchase_process_id|
    joins(list_purchase_solicitations: [:licitation_process]).where("compras_licitation_processes.id = ?", purchase_process_id)
  }

  scope :by_material_id, lambda {|material_id|
    joins {items}.where {items.material_id.eq(material_id)}
  }

  scope :by_material, lambda {|material_ids|
    joins {items}.
        where {|purchase| purchase.items.material_id.in(material_ids)}
  }

  scope :except_ids, lambda {|ids| where {id.not_in(ids)}}

  scope :can_be_grouped, lambda {
    where {service_status.in [
                                 PurchaseSolicitationServiceStatus::LIBERATED,
                                 PurchaseSolicitationServiceStatus::PARTIALLY_FULFILLED]
    }.uniq
  }

  scope :without_price_collection, lambda {
    joins {price_collections.outer}.
        where {compras_price_collections_purchase_solicitations.price_collection_id.eq(nil)}
  }

  scope :without_purchase_process, lambda {
    joins {licitation_processes.outer}.
        where {licitation_processes.id.eq(nil)}
  }

  scope :term, lambda {|q|
    where {
          ((code.eq(q) & code.not_eq(0)) | budget_structure_description.like("#{q}%")
          )
    }
    # where {
    #   accounting_year.eq(Date.current.year) &
    #       (service_status.in [
    #                              PurchaseSolicitationServiceStatus::LIBERATED,
    #                              PurchaseSolicitationServiceStatus::PARTIALLY_FULFILLED]) &
    #       ((code.eq(q) & code.not_eq(0)) | budget_structure_description.like("#{q}%")
    #       )
    # }
  }

  def to_s
    "#{code}/#{accounting_year} #{budget_structure} - RESP: #{responsible}"
  end

  def can_be_grouped?
    liberated? || partially_fulfilled?
  end

  def total_items_value
    items.collect(&:estimated_total_price_rounded).sum
  end

  def change_status!(status)
    update_column :service_status, status
  end

  def quantity_by_material(material_id)
    PurchaseSolicitation.joins {items}.
        where {|purchase| purchase.items.material_id.eq(material_id) &
            purchase.id.eq(self.id)}.sum(:quantity)
  end

  def editable?
    pending? || returned?
  end

  def purchase_solicitation_budget_allocations_by_material(material_ids)
    purchase_solicitation_budget_allocations.by_material(material_ids)
  end

  def annul!
    update_column :service_status, PurchaseSolicitationServiceStatus::ANNULLED
  end

  def liberate!
    update_column :service_status, PurchaseSolicitationServiceStatus::LIBERATED
  end

  def attend!
    update_column :service_status, PurchaseSolicitationServiceStatus::ATTENDED
  end

  def buy!
    update_column :service_status, PurchaseSolicitationServiceStatus::IN_PURCHASE_PROCESS
  end

  def pending!
    update_column :service_status, PurchaseSolicitationServiceStatus::PENDING
  end

  def partially_fulfilled!
    update_column :service_status, PurchaseSolicitationServiceStatus::PARTIALLY_FULFILLED
  end

  def active_purchase_solicitation_liberation
    purchase_solicitation_liberations.last
  end

  def active_purchase_solicitation_liberation_liberated?
    return false unless active_purchase_solicitation_liberation

    active_purchase_solicitation_liberation.liberated?
  end

  def budget_allocations
    return unless purchase_solicitation_budget_allocations

    purchase_solicitation_budget_allocations.map(&:budget_allocation)
  end

  protected

  def items_blank?
    errors.add(:items, :blank) if items.blank?
  end

  def set_budget_structure_description
    self.budget_structure_description = budget_structure.present? ? budget_structure.description : ''
  end

  def must_have_at_least_one_item
    unless items?
      errors.add(:items, :must_have_at_least_one_item)
    end
  end

  def purchase_solicitation_budget_allocations?
    purchase_solicitation_budget_allocations.reject(&:marked_for_destruction?).any?
  end

  def items?
    items.reject(&:marked_for_destruction?).any?
  end

  def materials_of_other_peding_purchase_solicitation
    materials = Material.by_pending_purchase_solicitation_budget_structure_id(budget_structure_id)
    materials.not_purchase_solicitation(id)
  end

  def validate_budget_structure_and_materials
    items.each do |item|
      if materials_of_other_peding_purchase_solicitation.include?(item.material)
        errors.add(:base, :already_exists_a_pending_purchase_solicitation_with_this_budget_structure_and_material,
                   :budget_structure => budget_structure(false), :material => item.material)
      end
    end
  end

  def validate_liberated_status
    if !active_purchase_solicitation_liberation_liberated? && self.liberated?
      errors.add(:service_status, :not_yet_liberated)
    end
  end
end
