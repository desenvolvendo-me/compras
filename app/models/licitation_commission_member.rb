class LicitationCommissionMember < ActiveRecord::Base
  attr_accessible :licitation_commission_id, :individual_id, :role, :role_nature, :registration

  has_enumeration_for :role, :with => LicitationCommissionMemberRole
  has_enumeration_for :role_nature, :with => LicitationCommissionMemberRoleNature

  belongs_to :licitation_commission
  belongs_to :individual

  delegate :cpf, :to => :individual, :allow_nil => true, :prefix => true

  validates :individual, :role, :role_nature, :registration, :presence => true
end
