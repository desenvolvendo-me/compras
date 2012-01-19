class ReferenceUnit < ActiveRecord::Base
  attr_accessible :name, :acronym

  validates :name, :acronym, :presence => true, :uniqueness => { :allow_blank => true }
  validates_length_of :acronym, :maximum => 2, :allow_blank => true, :allow_nil => true

  filterize
  orderize

  def to_s
    name
  end
end
