class Organ < Compras::Model
  attr_accessible :code, :initial, :name, :category, :year

  has_enumeration_for :category, :with => OrganCategory, :create_helpers => true

  validates :name, :code, presence: true, uniqueness:true
  validates :year, :mask => "9999", :allow_blank => true

  orderize "created_at"
  filterize

  def to_s
    name
  end

end