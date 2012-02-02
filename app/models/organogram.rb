class Organogram < ActiveRecord::Base
  attr_accessible :name, :organogram, :tce_code, :acronym
  attr_accessible :performance_field, :configuration_organogram_id
  attr_accessible :type_of_administractive_act_id, :address_attributes

  validates :name, :organogram, :tce_code, :acronym, :presence => true
  validates :performance_field, :configuration_organogram_id, :presence => true
  validates :type_of_administractive_act_id, :presence => true
  validates :organogram, :mask => :mask

  has_one :address, :as => :addressable, :dependent => :destroy
  belongs_to :configuration_organogram
  belongs_to :type_of_administractive_act

  accepts_nested_attributes_for :address

  orderize
  filterize

  delegate :mask, :to => :configuration_organogram, :allow_nil => true

  def to_s
    name
  end
end
