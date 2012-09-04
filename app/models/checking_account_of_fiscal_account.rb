class CheckingAccountOfFiscalAccount < Compras::Model
  attr_accessible :function, :main_tag, :name, :tce_code

  validates :tce_code, :name, :main_tag, :presence => true

  orderize
  filterize

  def to_s
    name
  end
end
