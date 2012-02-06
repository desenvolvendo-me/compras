class PurchaseSolicitation < ActiveRecord::Base
  attr_accessible :accounting_year, :request_date, :responsible_id, :justification, :budget_allocation_id,
                  :delivery_location_id, :kind, :general_observations, :items_attributes, :budget_allocation_ids,
                  :organogram_id

  attr_protected :allocation_amount, :service_status, :liberation_date, :liberator, :service_observations,
                 :no_service_justification, :responsible, :liberator_id, :budget_allocation, :delivery_location,
                 :organogram

  has_enumeration_for :kind, :with => PurchaseSolicitationKind, :create_helpers => true
  has_enumeration_for :service_status, :with => PurchaseSolicitationServiceStatus, :create_helpers => true

  belongs_to :responsible, :class_name => 'Employee', :foreign_key => 'responsible_id'
  belongs_to :budget_allocation
  belongs_to :delivery_location
  belongs_to :liberator, :class_name => 'Employee', :foreign_key => 'liberator_id'
  belongs_to :organogram
  has_many :items, :class_name => 'PurchaseSolicitationItem', :dependent => :destroy

  has_and_belongs_to_many :budget_allocations

  validates :accounting_year, :request_date, :responsible_id,
            :delivery_location, :kind, :delivery_location_id, :presence => true
  validate :cannot_have_more_than_once_item_with_the_same_material

  orderize :request_date
  filterize

  accepts_nested_attributes_for :items, :reject_if => :all_blank, :allow_destroy => true

  def to_s
    justification
  end

  protected

  def cannot_have_more_than_once_item_with_the_same_material
    counter = Hash.new(0)
    items.each do |item|
      counter[item.material_id] += 1
    end

    items.each do |item|
      if counter[item.material_id] > 1
        item.errors.add(:material, I18n.translate('errors.messages.cannot_have_more_than_once_item_with_the_same_material'))
      end
    end
  end
end
