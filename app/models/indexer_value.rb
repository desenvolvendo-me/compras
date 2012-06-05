class IndexerValue < ActiveRecord::Base
  attr_accessible :indexer_id, :date, :value

  belongs_to :indexer

  validates :date, :value, :presence => true
  validates :date, :uniqueness => true, :allow_blank => true

  def self.current_value
    current.try(:value)
  end

  def self.current
    where { date.lteq Date.current }.order { date }.last
  end
end

