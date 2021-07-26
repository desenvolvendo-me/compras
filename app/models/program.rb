class Program < Compras::Model
  attr_accessible :code, :name

  validates :name, :code, presence: true, uniqueness:true
  validates :code, :mask => "9999", :allow_blank => true

  orderize "created_at"
  filterize

  def to_s
    "#{code}"
  end

end
