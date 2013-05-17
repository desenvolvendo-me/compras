class Partner < Persona::Partner
  attr_accessible :extended_partner_attributes

  has_one :extended_partner, inverse_of: :partner, dependent: :destroy

  accepts_nested_attributes_for :extended_partner, allow_destroy: true

  delegate :society_kind, :society_kind_humanize, to: :extended_partner, allow_nil: true

  validates :person_id, :uniqueness => { :scope => [:company_id] }
end
