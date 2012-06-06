class Indexer < ActiveRecord::Base
  attr_accessible :name, :currency_id, :indexer_values_attributes

  belongs_to :currency

  has_many :indexer_values, :dependent => :destroy, :order => :date
  belongs_to :currency

  accepts_nested_attributes_for :indexer_values

  validates :name, :presence => true

  filterize
  orderize

  delegate :current_value, :to => :indexer_values

  def to_s
    name.to_s
  end
end
