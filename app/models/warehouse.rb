class Warehouse < Compras::Model
  attr_accessible :code, :name, :acronym

  has_many :materials_controls, :dependent => :destroy

  def to_s
    name
  end
end
