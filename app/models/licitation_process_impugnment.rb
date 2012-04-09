class LicitationProcessImpugnment < ActiveRecord::Base
  attr_accessible :licitation_process_id, :person_id, :impugnment_date, :related, :valid_resson
  attr_accessible :situation, :judgment_date, :observation

  has_enumeration_for :related
  has_enumeration_for :situation

  belongs_to :licitation_process
  belongs_to :person

  delegate :year, :process_date, :object_description, :envelope_delivery_date, :envelope_delivery_time,
           :envelope_opening_date, :envelope_opening_time, :to => :licitation_process, :allow_nil => true, :prefix => true

  validates :licitation_process, :person, :impugnment_date, :related, :situation, :presence => true
  
  validates :impugnment_date, :timeliness => {
    :on_or_after => :licitation_process_process_date,
    :invalid_date_message => :must_be_greather_or_equal_to_licitation_process_process_date,
    :type => :date
  }

  validates :judgment_date, :timeliness => {
    :on_or_after => :impugnment_date,
    :invalid_date_message => :must_be_greather_or_equal_to_impugnment_date,
    :type => :date
  }

  orderize :impugnment_date
  filterize

  def to_s
    self.id.to_s
  end
end