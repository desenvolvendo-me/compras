class LegalTextsNature < ActiveRecord::Base
  attr_accessible :name

  attr_modal :name

  validates :name, :presence => true, :uniqueness => true

  orderize
  filterize

  def to_s
    name
  end
end
