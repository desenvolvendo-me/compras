class Signature < ActiveRecord::Base
  attr_accessible :person_id, :position_id

  belongs_to :person
  belongs_to :position

  validates :person, :position, :presence => true

  orderize :position_id
  filterize

  def to_s
    person.to_s
  end
end
