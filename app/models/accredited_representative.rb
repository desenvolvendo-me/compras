class AccreditedRepresentative < Compras::Model
  attr_accessible :person_id, :bidder_id

  belongs_to :person
  belongs_to :bidder
end
