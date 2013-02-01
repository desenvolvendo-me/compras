class Setting < Compras::Model
  attr_accessible :prefecture_id, :allow_insert_past_processes

  belongs_to :prefecture

  validates :prefecture, :presence => true
end
