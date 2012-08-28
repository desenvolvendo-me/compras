class Indexer < Compras::Model
  attr_accessible :name, :currency_id, :indexer_values_attributes

  attr_modal :name

  belongs_to :currency

  has_many :indexer_values, :dependent => :destroy, :order => :date
  has_many :licitation_processes, :dependent => :restrict, :foreign_key => :readjustment_index_id

  accepts_nested_attributes_for :indexer_values

  validates :name, :presence => true

  filterize
  orderize

  def to_s
    name.to_s
  end
end
