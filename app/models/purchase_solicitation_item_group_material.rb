class PurchaseSolicitationItemGroupMaterial < Compras::Model
  attr_accessible :material_id, :purchase_solicitation_item_group_id,
                  :purchase_solicitation_ids

  belongs_to :purchase_solicitation_item_group
  belongs_to :material

  has_many :purchase_solicitation_item_group_material_purchase_solicitations, :dependent => :destroy
  has_many :purchase_solicitations, :through => :purchase_solicitation_item_group_material_purchase_solicitations
  has_many :purchase_solicitation_items, :through => :purchase_solicitations,
           :source => :items, :conditions => Proc.new { { :material_id => material_id } }

  validates :purchase_solicitations, :presence => { :message => :must_have_at_least_one_purchase_solicitation }
  validates :material, :presence => true
  validate  :purchase_solicitation_status, :on => :create

  def fulfill_items(process)
    purchase_solicitation_items.fulfill_items({
      :material_id => material_id,
      :process => process
    })
  end

  private

  def purchase_solicitation_status
    return unless purchase_solicitations.any?

    unavailable_purchases = purchase_solicitations.reject(&:can_be_grouped?)

    if unavailable_purchases.any?
      errors.add(:purchase_solicitations, :should_have_liberated_or_partially_fulfilled_status)
    end
  end
end
