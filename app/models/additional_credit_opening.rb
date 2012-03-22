class AdditionalCreditOpening < ActiveRecord::Base
  attr_accessible :entity_id, :year, :credit_type, :administractive_act_id

  has_enumeration_for :credit_type, :with => AdditionalCreditOpeningCreditType

  belongs_to :entity
  belongs_to :administractive_act

  delegate :administractive_act_type, :publication_date, :to => :administractive_act, :allow_nil => true

  validates :year, :mask => '9999'
  validates :year, :entity, :credit_type, :presence => true
  validates :administractive_act, :presence => true
  validates :administractive_act_id, :uniqueness => { :message => :must_be_uniqueness_on_additional_credit_opening }, :allow_blank => true

  orderize :year
  filterize

  def to_s
    "#{year}"
  end
end
