class LicitationCommissionResponsible < Compras::Model
  attr_accessible :licitation_commission_id, :individual_id, :role, :class_register

  has_enumeration_for :role, :with => LicitationCommissionResponsibleRole, :create_helpers => true

  belongs_to :licitation_commission
  belongs_to :individual

  delegate :cpf, :to => :individual, :allow_nil => true, :prefix => true

  validates :individual, :role, :presence => true
  validates :class_register, :presence => true, :if => :lawyer?

  before_save :clean_class_register_when_is_no_lawyer

  protected

  def clean_class_register_when_is_no_lawyer
    return if role.blank? || class_register.blank?

    unless lawyer?
      self.class_register = nil
    end
  end
end
