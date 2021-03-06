class LicitationProcessImpugnment < Compras::Model
  attr_accessible :licitation_process_id, :person_id, :impugnment_date, :related
  attr_accessible :valid_reason

  has_enumeration_for :related
  has_enumeration_for :situation, :create_helpers => true

  belongs_to :licitation_process
  belongs_to :person

  delegate :year, :process_date, :description, :envelope_delivery_date,
           :envelope_delivery_time, :proposal_envelope_opening_date, :proposal_envelope_opening_time,
           :to => :licitation_process, :allow_nil => true, :prefix => true

  validates :licitation_process, :person, :related, :situation, :impugnment_date, :presence => true
  validates :new_envelope_delivery_time, :timeliness => { :type => :time }, :if => :new_envelope_delivery_date?
  validates :new_proposal_envelope_opening_time, :timeliness => { :type => :time }, :if => :new_proposal_envelope_opening_date?

  with_options :allow_blank => true do |allowing_blank|
    allowing_blank.validates :impugnment_date, :timeliness => {
      :on_or_after => :licitation_process_process_date,
      :on_or_after_message => :must_be_greater_or_equal_to_licitation_process_process_date,
      :type => :date
    }
    allowing_blank.validates :judgment_date, :timeliness => {
      :on_or_after => :impugnment_date,
      :on_or_after_message => :must_be_greater_or_equal_to_impugnment_date,
      :type => :date
    }
  end

  orderize :impugnment_date
  filterize

  def to_s
    "#{licitation_process} - #{I18n.l(impugnment_date)}"
  end

  def self.by_licitation_process(params = {})
    if params[:licitation_process_id].present?
      where { licitation_process_id.eq(params.fetch(:licitation_process_id)) }
    else
      all
    end
  end
end
