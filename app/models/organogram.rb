class Organogram < ActiveRecord::Base
  attr_accessible :name, :organogram, :tce_code, :acronym
  attr_accessible :performance_field, :configuration_organogram_id
  attr_accessible :type_of_administractive_act_id, :address_attributes
  attr_accessible :organogram_responsibles_attributes, :organogram_kind

  attr_modal :name

  has_enumeration_for :organogram_kind, :create_helpers => true

  validates :name, :organogram, :tce_code, :acronym, :presence => true
  validates :performance_field, :configuration_organogram_id, :presence => true
  validates :type_of_administractive_act_id, :organogram_kind, :presence => true
  validates :organogram, :mask => :mask

  has_one :address, :as => :addressable, :dependent => :destroy
  belongs_to :configuration_organogram
  belongs_to :type_of_administractive_act
  has_many :purchase_solicitations
  has_many :organogram_responsibles, :dependent => :destroy

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :organogram_responsibles, :reject_if => :all_blank, :allow_destroy => true

  orderize
  filterize

  delegate :mask, :to => :configuration_organogram, :allow_nil => true

  def to_s
    name
  end
end
