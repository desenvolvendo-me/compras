class LicitationCommissionMember < Compras::Model
  attr_accessible :licitation_commission_id, :individual_id, :role, :role_nature, :registration

  has_enumeration_for :role, with: LicitationCommissionMemberRole,
    create_helpers: true, create_scopes: true
  has_enumeration_for :role_nature, with: LicitationCommissionMemberRoleNature

  belongs_to :licitation_commission
  belongs_to :individual

  has_one :regulatory_act, through: :licitation_commission
  has_one :person, through: :individual
  has_one :employee, through: :individual
  has_one :street, through: :individual
  has_one :neighborhood, through: :individual
  has_one :position, through: :employee

  has_many :judgment_commission_advice_members, dependent: :restrict

  delegate :cpf, :name, :zip_code, :phone, :email, :to_s,
    to: :individual, allow_nil: true, prefix: true
  delegate :city, :state, to: :individual, allow_nil: true
  delegate :tce_mg_code, to: :city, allow_nil: true, prefix: true
  delegate :acronym, to: :state, allow_nil: true, prefix: true
  delegate :name, to: :position, allow_nil: true, prefix: true
  delegate :name, to: :street, allow_nil: true, prefix: true
  delegate :name, to: :neighborhood, allow_nil: true, prefix: true
  delegate :permanent?, :nomination_date,
    to: :licitation_commission, allow_nil: true, prefix: true
  delegate :classification_ordinance?, :classification_decree?, :act_number, :vigor_date, :end_date,
    to: :regulatory_act, allow_nil: true, prefix: true

  validates :individual, :role, :role_nature, :registration, presence: true

  def to_s
    individual_to_s
  end
end
