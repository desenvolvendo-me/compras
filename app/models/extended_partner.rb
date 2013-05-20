class ExtendedPartner < Compras::Model
  attr_accessible :partner_id, :society_kind

  has_enumeration_for :society_kind, create_helpers: { prefix: true }

  belongs_to :partner

  validates :society_kind, :partner,  presence: true
end
