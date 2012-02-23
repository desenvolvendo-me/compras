class ManagementUnit < ActiveRecord::Base
  attr_accessible :description, :acronym, :status

  orderize :description
  filterize

  has_many :pledges, :dependent => :restrict

  has_enumeration_for :status, :create_helpers => true, :with => ManagementUnitStatus

  def to_s
    description
  end
end
