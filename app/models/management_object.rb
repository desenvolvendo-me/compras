class ManagementObject < Compras::Model
  attr_accessible :description, :status, :object, :purchase_solicitation_objects_attributes

  attr_modal :description, :status
  has_enumeration_for :status, with: ObjectStatus

  has_many :purchase_solicitation_objects
  has_many :purchase_solicitations, through: :purchase_solicitation_objects

  accepts_nested_attributes_for :purchase_solicitation_objects, allow_destroy: true

  validates :description, :status, presence: true

  orderize :id
  filterize

  def to_s
    description
  end
end
