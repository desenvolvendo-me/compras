class LegalTextNature < ActiveRecord::Base
  attr_accessible :description

  has_many :regulatory_acts, :dependent => :restrict

  validates :description, :presence => true, :uniqueness => { :allow_blank => true }

  orderize :description
  filterize

  def to_s
    description
  end
end
