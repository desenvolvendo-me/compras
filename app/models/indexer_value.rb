class IndexerValue < Compras::Model
  attr_accessible :indexer_id, :date, :value

  belongs_to :indexer

  validates :date, :value, :presence => true
  validates :date, :uniqueness => true, :allow_blank => true

  def self.current
    where { date.lteq Date.current }.order { date }.last
  end

  def scale_of_value
    column_for_attribute(:value).try(:scale)
  end
end
