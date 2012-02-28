class Owner < ActiveRecord::Base
  attr_accessible :person_id, :property_id

  belongs_to :property
  belongs_to :person

  def to_s
    person
  end
end
