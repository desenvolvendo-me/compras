class Provider < ActiveRecord::Base
  attr_accessible :person_id

  belongs_to :person

  validates :person, :presence => true

  orderize :person_id
  filterize

  def to_s
    id.to_s
  end
end
