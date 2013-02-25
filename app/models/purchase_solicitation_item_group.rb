class PurchaseSolicitationItemGroup < Compras::Model
  attr_accessible :description,
                  :purchase_solicitation_item_group_materials_attributes

  attr_accessor :purchase_solicitation, :purchase_solicitation_id,
                :material, :material_id

  attr_modal :description

  has_enumeration_for :status, :with => PurchaseSolicitationItemGroupStatus,
                               :create_helpers => true,
                               :create_scopes => true

  has_many :purchase_solicitation_item_group_materials, :dependent => :destroy
  has_many :purchase_solicitations, :through => :purchase_solicitation_item_group_materials, :uniq => true
  has_one :direct_purchase, :dependent => :restrict
  has_one :administrative_process, :dependent => :restrict
  has_one :annul, :class_name => 'ResourceAnnul', :as => :annullable, :dependent => :destroy

  validates :description, :presence => true
  validates :purchase_solicitation_item_group_materials, :presence => {:message => :must_have_at_least_one_material}
  validate :purchase_solicitation_status

  accepts_nested_attributes_for :purchase_solicitation_item_group_materials, :allow_destroy => true

  delegate :authorized?, :to => :direct_purchase, :prefix => true, :allow_nil => true

  orderize "id DESC"

  def self.filter(options)
    query = scoped
    query = query.joins { purchase_solicitations }.
                  where { purchase_solicitations.id.eq options[:purchase_solicitation_id] } if options[:purchase_solicitation_id].present?
    query = query.joins { purchase_solicitation_item_group_materials }.
                  where { purchase_solicitation_item_group_materials.material_id.eq options[:material_id] } if options[:material_id].present?
    query
  end

  def self.not_annulled
    joins { annul.outer }.where { annul.id.eq nil }
  end

  def total_purchase_solicitation_budget_allocations_sum
    purchase_solicitations.sum(&:total_allocations_items_value)
  end

  def to_s
    description
  end

  def purchase_solicitation_items
    purchase_solicitation_item_group_materials(true).flat_map(&:purchase_solicitation_items)
  end

  def purchase_solicitation_item_ids
    purchase_solicitation_items.map(&:id)
  end

  def editable?
    !(administrative_process || direct_purchase)
  end

  def annullable?
    editable?
  end

  def fulfill_items(process)
    purchase_solicitation_item_group_materials.each do |group_material|
      group_material.fulfill_items(process)
    end
  end

  def material_ids
    purchase_solicitation_item_group_materials.map(&:material_id)
  end

  def change_status!(status)
    update_column(:status, status)
  end

  def fulfill!
    change_status!(PurchaseSolicitationItemGroupStatus::FULFILLED)
  end

  def attend_items!
    purchase_solicitation_items.each(&:attend!)
  end

  def partially_fulfilled_items!
    purchase_solicitation_items.each(&:partially_fulfilled!)
  end

  def rollback_attended_items!
    purchase_solicitation_items.each(&:pending!)
  end

  private

  def purchase_solicitation_status
    return unless purchase_solicitations

    purchase_solicitations.each do |purchase_solicitation|
      unless purchase_solicitation.can_be_grouped?
        errors.add(:purchase_solicitations, :cannot_have_purchase_solicitation_not_liberated_or_partially_fulfilled, :purchase_solicitation => purchase_solicitation)
      end
    end
  end
end
