class PurchaseSolicitationItemGroupMaterial < Compras::Model
  attr_accessible :material_id, :purchase_solicitation_item_group_id,
                  :purchase_solicitation_ids

  belongs_to :purchase_solicitation_item_group
  belongs_to :material

  has_many :purchase_solicitation_item_group_material_purchase_solicitations, :dependent => :destroy
  has_many :purchase_solicitations, :through => :purchase_solicitation_item_group_material_purchase_solicitations
  has_many :purchase_solicitation_items, :through => :purchase_solicitations, :source => :items

  validates :purchase_solicitations, :presence => { :message => :must_have_at_least_one_purchase_solicitation }
  validates :material, :presence => true

  def fulfill_items(process)
    purchase_solicitation_items_by_material.each do |item|
      item.update_fulfiller(process)
    end
  end
  
  private

  def purchase_solicitation_items_by_material
    purchase_solicitation_items.by_material(material_id)
  end
end
