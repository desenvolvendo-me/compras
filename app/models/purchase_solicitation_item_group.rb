class PurchaseSolicitationItemGroup < Compras::Model
  attr_accessible :material_id, :purchase_solicitation_ids

  belongs_to :material

  has_many :purchase_solicitation_item_group_purchase_solicitations, :dependent => :destroy, :inverse_of => :purchase_solicitation_item_group
  has_many :purchase_solicitations, :through => :purchase_solicitation_item_group_purchase_solicitations
  has_many :purchase_solicitation_budget_allocations, :through => :purchase_solicitations
  has_many :items, :through => :purchase_solicitation_budget_allocations, :autosave => true

  validates :material, :presence => true
  validates :purchase_solicitations, :presence => { :message => :must_have_at_least_one_purchase_solicitation }

  scope :groups_less_than_me, lambda { |material_id_param, id_param, year| where {
    id.lteq(id_param) &
    material_id.eq(material_id_param) &
    extract(`year from created_at`).eq(year)}
  }

  filterize
  orderize :material_id

  def to_s
    "#{material} - #{count_groups}"
  end

  protected

  def count_groups
    self.class.groups_less_than_me(material_id, id, created_at.year).count
  end
end
