class Setting < Compras::Model
  attr_accessible :key, :value

  validates :key, :presence => true

  filterize
  orderize :key

  def self.fetch(key)
    find_by_key(key.to_s).try(:value)
  end

  def to_s
    I18n.translate(key, :scope => :settings)
  end
end
