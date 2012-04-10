class AdministrativeProcess < ActiveRecord::Base
  attr_accessible :budget_unit_id, :responsible_id
  attr_accessible :process, :year, :date, :modality
  attr_accessible :protocol, :object_type, :status, :description
  attr_accessible :judgment_form_id

  attr_modal :year, :process, :protocol, :budget_unit_id

  attr_readonly :process, :year

  has_enumeration_for :modality, :with => AdministrativeProcessModality
  has_enumeration_for :object_type, :with => AdministrativeProcessObjectType
  has_enumeration_for :status, :with => AdministrativeProcessStatus

  belongs_to :budget_unit
  belongs_to :responsible, :class_name => 'Employee'
  belongs_to :judgment_form

  has_many :licitation_processes, :dependent => :restrict

  validates :year, :date, :budget_unit, :presence => true
  validates :modality, :object_type, :presence => true
  validates :responsible, :status, :presence => true
  validates :description, :judgment_form, :presence => true
  validates :year, :mask => '9999', :allow_blank => true

  validate :validate_modality

  before_create :set_process

  orderize :year
  filterize

  def to_s
    "#{process}/#{year}"
  end

  protected

  def set_process
    last = self.class.where(:year => year).last

    if last
      self.process = last.process.to_i + 1
    else
      self.process = 1
    end
  end

  def validate_modality(verificator = AdministrativeProcessModalitiesByObjectType.new)
    return unless object_type.present? && modality.present?

    unless verificator.verify_modality(object_type, modality)
      errors.add(:modality, :inclusion)
    end
  end
end
