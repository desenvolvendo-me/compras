class ResourceSource < Compras::Model
  attr_accessible :code, :name, :number_convention, :year

  validates :code, :name,:year, presence: true, uniqueness:true
  validates :year, :mask => "9999", :allow_blank => true
  validates :code, :mask => "999", :allow_blank => true

  orderize "created_at"
  filterize

  def to_s
    name
  end

end
