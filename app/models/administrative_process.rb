class AdministrativeProcess < Compras::Model
  include Signable

  attr_accessible :responsible_id, :process, :purchase_solicitation_id,
                  :date, :year, :protocol, :object_type, :status, :description,
                  :judgment_form_id, :purchase_solicitation_item_group_id,
                  :administrative_process_budget_allocations_attributes,
                  :summarized_object, :modality

  attr_readonly :process, :year

  attr_modal :year, :process, :protocol

  has_enumeration_for :object_type, :with => AdministrativeProcessObjectType,
                      :create_helpers => true
  has_enumeration_for :status, :with => AdministrativeProcessStatus,
                      :create_helpers => true, :create_scopes => true
  has_enumeration_for :modality, :create_helpers => true, :create_scopes => true

  belongs_to :responsible, :class_name => 'Employee'
  belongs_to :judgment_form
  belongs_to :purchase_solicitation_item_group
  belongs_to :purchase_solicitation

  has_one  :licitation_process, :dependent => :restrict
  has_one  :administrative_process_liberation, :dependent => :destroy
  has_one  :delivery_location, :through => :purchase_solicitation
  has_many :administrative_process_budget_allocations, :dependent => :destroy, :order => :id
  has_many :items, :through => :administrative_process_budget_allocations, :order => :id
  has_many :materials, :through => :items
  has_many :purchase_solicitation_budget_allocation_items, :as => :fulfiller
  has_many :purchase_solicitation_items,
           :class_name => 'PurchaseSolicitationBudgetAllocationItem',
           :finder_sql => Proc.new { purchase_solicitation_items_finder_sql },
           :inverse_of => :fulfiller

  accepts_nested_attributes_for :administrative_process_budget_allocations, :allow_destroy => true

  delegate :kind, :best_technique?, :technical_and_price?, :licitation_kind,
           :to => :judgment_form, :allow_nil => true, :prefix => true

  delegate :type_of_calculation, :to => :licitation_process, :allow_nil => true

  validates :year, :date, :object_type, :responsible, :status, :description,
            :judgment_form, :modality, :presence => true
  validates :year, :mask => '9999', :allow_blank => true
  validates :administrative_process_budget_allocations, :no_duplication => :budget_allocation_id

  validate :validate_object_type_should_equal_modality_object_type
  validate :purchase_solicitation_item_group_annulled
  validate :validate_judgment_form_licitation_kind
  validate :has_either_purchase_solicitation_or_item_group

  before_create :set_process

  orderize :year
  filterize

  def to_s
    "#{process}/#{year}"
  end

  def total_allocations_value
    administrative_process_budget_allocations.sum(:value)
  end

  def update_status(new_status)
    update_column :status, new_status
  end

  def allow_licitation_process?
    purchase_and_services? || construction_and_engineering_services?
  end

  def attend_purchase_solicitation_items
    purchase_solicitation_items.attend!
  end

  def fulfill_purchase_solicitation_items
    purchase_solicitation_items.each do |item|
      item.fulfill(self)
    end
  end

  def remove_fulfill_purchase_solicitation_items
    purchase_solicitation_items.each do |item|
      item.fulfill(nil)
    end
  end

  def partially_fulfilled_purchase_solicitation_items
    purchase_solicitation_items.each do |item|
      item.partially_fulfilled!
    end
  end

  private

  def has_either_purchase_solicitation_or_item_group
    if purchase_solicitation.present? && purchase_solicitation_item_group.present?
      errors.add(:purchase_solicitation, :should_be_blank_if_item_group_is_present)
    end
  end

  def set_process
    last = self.class.where(:year => year).last

    if last
      self.process = last.process.to_i + 1
    else
      self.process = 1
    end
  end

  def validate_object_type_should_equal_modality_object_type
    return unless object_type.present? && modality.present?

    unless Modality.available_for_object_type(object_type).include?(modality)
      errors.add(:modality, :inclusion)
    end
  end

  def purchase_solicitation_item_group_annulled
    return unless purchase_solicitation_item_group.present?

    if purchase_solicitation_item_group.annulled?
      errors.add(:purchase_solicitation_item_group, :is_annulled)
    end
  end

  def validate_judgment_form_licitation_kind(verificator = JudgmentFormLicitationKindByObjectType.new)
    return unless judgment_form.present? && object_type.present?

    unless verificator.valid_licitation_kind?(object_type, judgment_form_licitation_kind)
      errors.add(:judgment_form, :invalid_licitation_kind_of_judgment_form_for_object_type, :object_type => object_type_humanize)
    end
  end

  def material_ids_or_zero
    return 0 if material_ids.size == 0

    material_ids.join(',')
  end

  def purchase_solicitation_items_finder_sql
    %Q{
      SELECT "compras_purchase_solicitation_budget_allocation_items".* FROM "compras_administrative_processes"
        INNER JOIN "compras_purchase_solicitations" ON
          "compras_purchase_solicitations"."id" = "compras_administrative_processes"."purchase_solicitation_id"
        INNER JOIN "compras_purchase_solicitation_budget_allocations" ON
          "compras_purchase_solicitation_budget_allocations"."purchase_solicitation_id" = "compras_purchase_solicitations"."id"
        INNER JOIN "compras_purchase_solicitation_budget_allocation_items" ON
          "compras_purchase_solicitation_budget_allocation_items"."purchase_solicitation_budget_allocation_id" = "compras_purchase_solicitation_budget_allocations"."id"
        WHERE (("compras_administrative_processes"."id" = #{id} AND
          "compras_purchase_solicitation_budget_allocation_items"."material_id" IN (#{material_ids_or_zero})))
    }
  end
end
