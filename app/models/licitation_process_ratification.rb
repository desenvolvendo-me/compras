class LicitationProcessRatification < Compras::Model
  attr_accessible :adjudication_date, :ratification_date, :licitation_process_id, :licitation_process_bidder_id
  attr_accessible :licitation_process_bidder_proposals_attributes

  belongs_to :licitation_process
  belongs_to :licitation_process_bidder

  has_many :licitation_process_bidder_proposals, :dependent => :restrict, :order => :id

  accepts_nested_attributes_for :licitation_process_bidder_proposals, :allow_destroy => true

  validates :licitation_process, :licitation_process_bidder, :presence => true
  validates :adjudication_date, :ratification_date, :presence => true
  validate :licitation_process_bidder_belongs_to_licitation_process, :if => :licitation_process_bidder

  auto_increment :sequence, :by => :licitation_process_id

  filterize
  orderize :licitation_process_id

  def to_s
    sequence.to_s
  end

  def licitation_process_bidder_belongs_to_licitation_process
    if licitation_process_bidder.licitation_process != licitation_process
      errors.add(:licitation_process_bidder,
                 :should_belongs_to_licitation_process,
                 :licitation_process => licitation_process)
    end
  end
end
