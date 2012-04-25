class LicitationCommissionMember < ActiveRecord::Base
  attr_accessible :licitation_commission_id, :individual_id, :role, :role_nature, :registration

  has_enumeration_for :role, :with => LicitationCommissionMemberRole, :create_helpers => true
  has_enumeration_for :role_nature, :with => LicitationCommissionMemberRoleNature

  belongs_to :licitation_commission
  belongs_to :individual

  delegate :cpf, :to => :individual, :allow_nil => true, :prefix => true

  validates :individual, :role, :role_nature, :registration, :presence => true

  def attributes_for_data
    { 'individual_id' => individual_id,
      'role' => role,
      'role_humanize' => role_humanize,
      'role_nature' => role_nature,
      'role_nature_humanize' => role_nature_humanize,
      'registration' => registration,
      'individual_name' => individual.to_s,
      'cpf' => individual_cpf }
  end

  def to_hash
    {:individual_id => individual_id,
     :role => role,
     :role_nature => role_nature,
     :registration => registration}
  end
end
