class LicitationCommissionMember < ActiveRecord::Base
  attr_accessible :licitation_commission_id, :individual_id, :role, :role_nature, :registration

  has_enumeration_for :role, :with => LicitationCommissionMemberRole, :create_helpers => true
  has_enumeration_for :role_nature, :with => LicitationCommissionMemberRoleNature

  belongs_to :licitation_commission
  belongs_to :individual

  has_many :judgment_commission_advice_members, :dependent => :restrict

  delegate :cpf, :to_s, :to => :individual, :allow_nil => true, :prefix => true

  validates :individual, :role, :role_nature, :registration, :presence => true

  def attributes_for_data
    { 'id' => id,
      'role_humanize' => role_humanize,
      'role_nature_humanize' => role_nature_humanize,
      'registration' => registration,
      'individual_name' => individual.to_s,
      'cpf' => individual_cpf }
  end

  def to_s
    individual_to_s
  end
end
