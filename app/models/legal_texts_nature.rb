class LegalTextsNature < ActiveRecord::Base
  attr_accessible :description

  attr_modal :description

  has_many :administractive_acts

  validates :description, :presence => true, :uniqueness => true

  orderize :description
  filterize

  def to_s
    description
  end
end
