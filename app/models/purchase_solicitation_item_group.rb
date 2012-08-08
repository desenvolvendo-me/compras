class PurchaseSolicitationItemGroup < Compras::Model
  attr_accessible :purchase_solicitation_item_group_materials_attributes

  attr_accessor :purchase_solicitation, :purchase_solicitation_id,
                :material, :material_id

  has_many :purchase_solicitation_item_group_materials, :dependent => :destroy
  has_many :purchase_solicitations, :through => :purchase_solicitation_item_group_materials

  validates :purchase_solicitation_item_group_materials, :presence => {:message => :must_have_at_least_one_material}

  accepts_nested_attributes_for :purchase_solicitation_item_group_materials, :allow_destroy => true

  orderize :id

  def self.filter(options)
    query = scoped
    query = query.joins { purchase_solicitations }.
                  where { purchase_solicitations.id.eq options[:purchase_solicitation_id] } if options[:purchase_solicitation_id].present?
    query = query.joins { purchase_solicitation_item_group_materials }.
                  where { purchase_solicitation_item_group_materials.material_id.eq options[:material_id] } if options[:material_id].present?
    query
  end

  def to_s
    "#{id}"
  end
end
