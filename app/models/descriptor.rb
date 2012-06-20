class Descriptor < Compras::Model
  attr_accessible :year, :entity_id

  belongs_to :entity

  validates :year, :entity, :presence => true
  validates :year, :mask => '9999', :allow_blank => true
  validates :entity_id, :uniqueness => { :scope => [:year] }, :allow_blank => true

  orderize :year
  filterize

  def to_s
    "#{year} - #{entity}"
  end
end
