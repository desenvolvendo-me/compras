class Profile < ActiveRecord::Base
  attr_accessible :name, :roles_attributes

  has_many :roles, :dependent => :destroy, :inverse_of => :profile
  has_many :users, :dependent => :restrict

  accepts_nested_attributes_for :roles

  validates :name, :presence => true, :uniqueness => { :allow_blank => true }

  filterize
  orderize

  def to_s
    name.to_s
  end

  def build_role(attributes)
    roles.build(attributes)
  end
end
