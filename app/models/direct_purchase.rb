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

  orderize :year

  def self.filter params={}
    relation = scoped
    relation = relation.where{ year.eq(params[:year]) } unless params[:year].blank?
    relation = relation.where{ date.eq(params[:date]) } unless params[:date].blank?
    relation = relation.where{ modality.eq(params[:modality]) } unless params[:modality].blank?
    relation = relation.by_status(params[:by_status]) unless params[:by_status].blank?
    relation
  end

  def self.by_status status = ''
    relation = scoped
    if status == 'authorized'
      relation = relation.joins(:supply_authorization)
    elsif status == 'unauthorized'
      relation = relation.where('direct_purchases.id not in (select direct_purchase_id from supply_authorizations)')
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
end
