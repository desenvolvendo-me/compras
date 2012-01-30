class CommunicationSource < ActiveRecord::Base
  attr_accessible :name

  validates :name, :presence => true

  has_many :dissemination_sources

  filterize
  orderize

  def to_s
    name
  end
end
