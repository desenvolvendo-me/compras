class PurchaseSolicitationItemGroup < Compras::Model
  attr_accessible :purchase_solicitation_item_group_materials_attributes

  has_many :purchase_solicitation_item_group_materials, :dependent => :destroy
  has_many :purchase_solicitations, :through => :purchase_solicitation_item_group_materials

  validates :purchase_solicitation_item_group_materials, :presence => {:message => :must_have_at_least_one_material}

  accepts_nested_attributes_for :purchase_solicitation_item_group_materials, :allow_destroy => true

  filterize
  orderize :id

  def to_s
    "#{id}"
  end
end
