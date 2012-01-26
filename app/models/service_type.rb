class ServiceType < ActiveRecord::Base
  attr_accessible :description, :tce_code, :service_goal

  validates :description, :tce_code, :service_goal, :presence => true

  has_enumeration_for :service_goal, :create_helpers => true

  filterize
  orderize :description

  def to_s
    description
  end
end
