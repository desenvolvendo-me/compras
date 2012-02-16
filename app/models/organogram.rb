class Organogram < ActiveRecord::Base
  attr_accessible :description, :organogram, :tce_code, :acronym
  attr_accessible :performance_field, :organogram_configuration_id
  attr_accessible :administration_type_id, :address_attributes
  attr_accessible :organogram_responsibles_attributes, :organogram_kind

  attr_modal :description

  has_enumeration_for :organogram_kind, :create_helpers => true

  has_one :address, :as => :addressable, :dependent => :destroy
  belongs_to :organogram_configuration
  belongs_to :administration_type
  has_many :purchase_solicitations, :dependent => :restrict
  has_many :organogram_responsibles, :dependent => :destroy

  validates :description, :organogram, :tce_code, :acronym, :presence => true
  validates :performance_field, :organogram_configuration_id, :presence => true
  validates :administration_type, :organogram_kind, :presence => true
  validates :organogram, :mask => :mask
  validate :cannot_have_duplicated_responsibles

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :organogram_responsibles, :reject_if => :all_blank, :allow_destroy => true

  orderize :description
  filterize

  delegate :mask, :to => :organogram_configuration, :allow_nil => true

  def to_s
    description
  end

  protected

  def cannot_have_duplicated_responsibles
    single_responsibles = []

    organogram_responsibles.each do |organogram_responsible|
      if single_responsibles.include?(organogram_responsible.responsible_id)
        errors.add(:organogram_responsibles)
        organogram_responsible.errors.add(:responsible_id, :taken)
      end
      single_responsibles << organogram_responsible.responsible_id
    end
  end
end
