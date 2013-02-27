class LicitationProcessAppeal < Compras::Model
  attr_accessible :licitation_process_id, :appeal_date, :related, :person_id, :valid_reason
  attr_accessible :new_envelope_opening_date, :new_envelope_opening_time
  attr_accessible :licitation_committee_opinion, :situation

  has_enumeration_for :related, :with => LicitationProcessAppealRelated
  has_enumeration_for :situation

  belongs_to :licitation_process
  belongs_to :person

  delegate :description, :process_date,
           :to => :licitation_process, :allow_nil => true, :prefix => true

  validates :licitation_process, :person, :appeal_date, :presence => true

  validates :appeal_date, :timeliness => {
    :on_or_after => :licitation_process_process_date,
    :on_or_after_message => :must_be_greater_or_equal_to_licitation_process_process_date,
    :type => :date,
    :allow_blank => true
  }

  orderize :appeal_date
  filterize

  def to_s
    id.to_s
  end
end
