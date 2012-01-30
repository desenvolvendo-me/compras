class CommunicationSource < ActiveRecord::Base
  attr_accessible :name

  has_many :dissemination_sources

  validates :name, :presence => true
  validates :name, :uniqueness => true

  filterize
  orderize

  def to_s
    name
  end
end
