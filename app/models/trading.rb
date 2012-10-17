class Trading < Compras::Model
  attr_accessible :code, :entity_id, :licitating_unit_id,
                  :summarized_object, :year

  auto_increment :code, :by => :year

  belongs_to :entity
  belongs_to :licitating_unit, :class_name => "Entity",
                               :foreign_key => "licitating_unit_id"

  orderize :code
  filterize

  def to_s
    "#{code}/#{year}"
  end
end
