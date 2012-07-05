class TargetAudience < Compras::Model
  attr_accessible :specification, :observation

  validates :specification, :presence => true

  orderize :specification
  filterize

  def to_s
    specification
  end
end
