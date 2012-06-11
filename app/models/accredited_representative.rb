class AccreditedRepresentative < ActiveRecord::Base
  attr_accessible :person_id, :licitation_process_bidder_id

  belongs_to :person
  belongs_to :licitation_process_bidder
end
