class ExtendedPrefecture < Compras::Model
  attr_accessible :prefecture_id, :organ_code, :organ_kind, :control_fractionation

  belongs_to :prefecture

  validates :prefecture, presence: true
end
