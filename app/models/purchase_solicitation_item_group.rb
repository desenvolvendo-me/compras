class PurchaseSolicitationItemGroup < Compras::Model
  attr_accessible :description,
                  :purchase_solicitation_item_group_materials_attributes

  attr_accessor :purchase_solicitation, :purchase_solicitation_id,
                :material, :material_id

  attr_modal :description

  has_many :purchase_solicitation_item_group_materials, :dependent => :destroy
  has_many :purchase_solicitations, :through => :purchase_solicitation_item_group_materials
  has_many :direct_purchases, :dependent => :restrict
  has_many :administrative_processes, :dependent => :restrict
  has_one :annul, :class_name => 'ResourceAnnul', :as => :annullable, :dependent => :destroy

  validates :description, :presence => true
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

  def self.not_annulled
    joins { annul.outer }.where { annul.id.eq nil }
  end

  def total_purchase_solicitation_budget_allocations_sum
    purchase_solicitations.sum(&:total_allocations_items_value)
  end

  def to_s
    description
  end

  def annulled?
    annul.present?
  end

  def editable?
    administrative_processes.empty? && direct_purchases.empty?
  end

  def annullable?
    editable?
  end
end
