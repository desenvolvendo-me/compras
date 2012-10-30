class ApplicationCode < Compras::Model
  attr_accessible :code, :name, :source, :specification, :variable

  has_enumeration_for :source

  validates :code, :name, :specification, :source, :presence => true
  validates :code, :uniqueness => { :scope => :variable, :message => :taken_for_variable }, :allow_blank => true

  orderize
  filterize

  def to_s
    name
  end
end
