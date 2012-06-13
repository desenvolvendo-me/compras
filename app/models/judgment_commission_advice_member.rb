class JudgmentCommissionAdviceMember < Compras::Model
  attr_accessible :judgment_commission_advice_id, :individual_id, :role, :role_nature, :registration
  attr_accessible :licitation_commission_member_id

  has_enumeration_for :role, :with => LicitationCommissionMemberRole, :create_helpers => true
  has_enumeration_for :role_nature, :with => LicitationCommissionMemberRoleNature

  belongs_to :judgment_commission_advice
  belongs_to :individual
  belongs_to :licitation_commission_member

  delegate :cpf, :to_s, :to => :individual, :allow_nil => true, :prefix => true

  delegate :individual_cpf, :role_humanize, :role_nature_humanize, :registration, :to_s, :individual_id,
           :to => :licitation_commission_member, :allow_nil => true, :prefix => true

  validates :individual, :role, :role_nature, :registration, :presence => true, :unless => :inherited?

  def inherited?
    licitation_commission_member.present?
  end

  def individual_identification
    if licitation_commission_member.present?
      licitation_commission_member_individual_id
    else
      individual_id
    end
  end
end
