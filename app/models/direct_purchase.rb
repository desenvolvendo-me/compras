class DirectPurchase < ActiveRecord::Base
  attr_accessible :year, :date, :legal_reference_id, :modality, :provider_id, :organogram_id
  attr_accessible :licitation_object_id, :delivery_location_id, :employee_id, :payment_method_id
  attr_accessible :price_collection, :price_registration, :observation, :period_id
  attr_accessible :direct_purchase_budget_allocations_attributes

  attr_modal :year, :date, :modality

  has_enumeration_for :modality, :create_helpers => true, :with => DirectPurchaseModality
  has_enumeration_for :status, :with => DirectPurchaseStatus

  belongs_to :legal_reference
  belongs_to :provider
  belongs_to :organogram
  belongs_to :licitation_object
  belongs_to :delivery_location
  belongs_to :employee
  belongs_to :payment_method
  belongs_to :period

  has_many :direct_purchase_budget_allocations, :dependent => :destroy, :inverse_of => :direct_purchase, :order => :id
  has_one :supply_authorization, :dependent => :restrict

  accepts_nested_attributes_for :direct_purchase_budget_allocations, :reject_if => :all_blank, :allow_destroy => true

  validates :year, :mask => "9999"
  validates :status, :year, :date, :legal_reference, :modality, :presence => true
  validates :organogram, :licitation_object, :delivery_location, :presence => true
  validates :provider, :employee, :payment_method, :period, :presence => true

  validate :cannot_have_duplicated_budget_allocations
  validate :must_have_at_least_budget_allocation
  validate :material_must_have_same_licitation_object
  validate :total_of_items_should_not_exceed_licitation_object_exemption

  orderize :year

  def licitation_exemption
    return 0 if licitation_object.nil? || modality.empty?

    licitation_object.licitation_exemption(modality)
  end

  def total_allocations_items_value
    direct_purchase_budget_allocations.collect(&:total_items_value).sum
  end

  def self.filter(params={})
    relation = scoped
    relation = relation.where{ year.eq(params[:year]) } unless params[:year].blank?
    relation = relation.where{ date.eq(params[:date]) } unless params[:date].blank?
    relation = relation.where{ modality.eq(params[:modality]) } unless params[:modality].blank?
    relation = relation.by_status(params[:by_status]) unless params[:by_status].blank?
    relation
  end

  def self.by_status(status = '')
    relation = scoped
    if status == 'authorized'
      relation = relation.joins(:supply_authorization)
    elsif status == 'unauthorized'
      relation = relation.joins { supply_authorization.outer }.where { supply_authorization.id.eq(nil) }
    end

    relation
  end

  def to_s
    id.to_s
  end

  protected

  def cannot_have_duplicated_budget_allocations
   single_allocations = []

   direct_purchase_budget_allocations.each do |allocation|
     if single_allocations.include?(allocation.budget_allocation_id)
       errors.add(:direct_purchase_budget_allocations)
       allocation.errors.add(:budget_allocation_id, :taken)
     end
     single_allocations << allocation.budget_allocation_id
   end
  end

  def must_have_at_least_budget_allocation
    return unless direct_purchase_budget_allocations.empty?

    errors.add(:direct_purchase_budget_allocations)
    direct_purchase_budget_allocations.build.valid?
  end

  def material_must_have_same_licitation_object
    direct_purchase_budget_allocations.each do |dpba|
      dpba.items.each do |item|
        if item.material && !item.material.licitation_object_ids.include?(licitation_object_id)
          errors.add(:direct_purchase_budget_allocations)
          item.errors.add(:material, :must_be_equal_as_licitation_object)
        end
      end
    end
  end

  def total_of_items_should_not_exceed_licitation_object_exemption
    if total_allocations_items_value > licitation_exemption
      errors.add(:total_allocations_items_value, :cannot_be_greater_than_licitation_exemption)
    end
  end
end
