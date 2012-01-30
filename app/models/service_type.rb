class ServiceType < ActiveRecord::Base
  attr_accessible :name, :tce_code, :service_goal

  validates :name, :tce_code, :service_goal, :presence => true
  validates :name, :uniqueness => true

  has_enumeration_for :service_goal, :create_helpers => true

  filterize
  orderize

  def to_s
    name
  end
end
