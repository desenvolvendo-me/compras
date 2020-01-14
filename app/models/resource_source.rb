class ResourceSource < Compras::Model
  attr_accessible :code, :name, :number_convention, :year

  validates :code, :name, presence: true, uniqueness:true
  validates :year, presence: true, :mask => "9999", :allow_blank => true
  validates :code, :mask => "9999", :allow_blank => true
  validates :number_convention, :mask => "999999999", :allow_blank => true

  orderize "created_at"
  filterize

  def to_s
    "#{code}"
  end

end
