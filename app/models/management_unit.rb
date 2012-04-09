class ManagementUnit < ActiveRecord::Base
  attr_accessible :description, :acronym, :status, :entity_id, :year

  has_enumeration_for :status, :create_helpers => true

  belongs_to :entity

  has_many :pledges, :dependent => :restrict

  validates :entity, :year, :description, :acronym, :status, :presence => true
  validates :year, :mask => "9999", :allow_blank => true

  orderize :description
  filterize

  def to_s
    description
  end
end
