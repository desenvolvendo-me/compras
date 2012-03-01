class EconomicRegistration < ActiveRecord::Base
  attr_accessible :registration, :person_id

  attr_modal :registration, :person_id

  belongs_to :person

  orderize :registration
  filterize

  def to_s
    registration
  end
end
