class Organogram < ActiveRecord::Base
  attr_accessible :description, :organogram, :tce_code, :acronym
  attr_accessible :performance_field, :organogram_configuration_id
  attr_accessible :administration_type_id, :address_attributes
  attr_accessible :organogram_responsibles_attributes, :organogram_kind

  attr_modal :description

  has_enumeration_for :organogram_kind, :create_helpers => true

  validates :description, :organogram, :tce_code, :acronym, :presence => true
  validates :performance_field, :organogram_configuration_id, :presence => true
  validates :administration_type, :organogram_kind, :presence => true
  validates :organogram, :mask => :mask

  has_one :address, :as => :addressable, :dependent => :destroy
  belongs_to :organogram_configuration
  belongs_to :administration_type
  has_many :purchase_solicitations
  has_many :organogram_responsibles, :dependent => :destroy

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :organogram_responsibles, :reject_if => :all_blank, :allow_destroy => true

  orderize :description
  filterize

  delegate :mask, :to => :organogram_configuration, :allow_nil => true

  def to_s
    description
  end
end
