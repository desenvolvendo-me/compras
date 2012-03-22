class AdditionalCreditOpening < ActiveRecord::Base
  attr_accessible :entity_id, :year, :credit_type, :administractive_act_id
  attr_accessible :credit_date

  has_enumeration_for :credit_type, :with => AdditionalCreditOpeningCreditType

  belongs_to :entity
  belongs_to :administractive_act

  delegate :administractive_act_type, :publication_date, :to => :administractive_act, :allow_nil => true

  validates :year, :mask => '9999'
  validates :year, :entity, :credit_type, :presence => true
  validates :administractive_act, :credit_date, :presence => true
  validates :administractive_act_id, :uniqueness => { :message => :must_be_uniqueness_on_additional_credit_opening }, :allow_blank => true
  validates :credit_date, :timeliness => {
    :on_or_after => lambda { last.credit_date },
    :on_or_after_message => :must_be_greather_or_equal_to_last_credit_date,
    :type => :date
  }, :allow_blank => true, :if => :any_additional_credit_opening?
  validates :credit_date, :timeliness => {
    :on_or_after => :publication_date,
    :on_or_after_message => :must_be_greather_or_equal_to_publication_date,
    :type => :date
  }, :allow_blank => true, :if => :publication_date

  orderize :year
  filterize

  def to_s
    "#{year}"
  end

  protected

  def any_additional_credit_opening?
    self.class.any?
  end
end
