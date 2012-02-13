class BranchClassification < ActiveRecord::Base
  attr_accessible :name

  validates :name, :presence => true, :uniqueness => { :allow_blank => true }

  filterize
  orderize

  def to_s
    name
  end
end
