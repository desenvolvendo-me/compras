class JudgmentCommissionAdviceMember < ActiveRecord::Base
  attr_accessible :judgment_commission_advice_id, :individual_id, :role, :role_nature, :registration

  has_enumeration_for :role, :with => LicitationCommissionMemberRole, :create_helpers => true
  has_enumeration_for :role_nature, :with => LicitationCommissionMemberRoleNature

  belongs_to :judgment_commission_advice
  belongs_to :individual

  delegate :cpf, :to_s, :to => :individual, :allow_nil => true, :prefix => true

  validates :individual, :role, :role_nature, :registration, :presence => true

  def to_hash
    {:individual_id => individual_id,
     :role => role,
     :role_nature => role_nature,
     :registration => registration}
  end
end
