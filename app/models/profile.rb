class Profile < Compras::Model
  attr_accessible :name, :roles_attributes, :auction_profile

  attr_modal :name

  has_many :roles, :dependent => :destroy, :inverse_of => :profile
  has_many :users, :dependent => :restrict
  after_validation :set_profile_admin

  accepts_nested_attributes_for :roles

  validates :name, :presence => true, :uniqueness => { :allow_blank => true }

  filterize
  orderize

  def to_s
    name.to_s
  end

  def set_profile_admin
    Profile.create(name: "Administrador") if self.name != "Administrador"
  end

  def build_role(attributes)
    roles.build(attributes)
  end

  def delete_role(role)
    roles.delete(role)
  end

  def get_profile_last_name
    name.split(" ").last
  end
end
