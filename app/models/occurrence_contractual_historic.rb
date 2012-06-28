class OccurrenceContractualHistoric < Compras::Model
  attr_accessible :observations, :occurrence_contractual_historic_change, :occurrence_contractual_historic_type
  attr_accessible :contract_id, :occurrence_date, :sequence

  has_enumeration_for :occurrence_contractual_historic_change
  has_enumeration_for :occurrence_contractual_historic_type

  belongs_to :contract

  validates :observations, :occurrence_contractual_historic_change, :presence => true
  validates :occurrence_contractual_historic_type, :occurrence_date, :presence => true

  before_create :set_code

  orderize :sequence
  filterize

  def to_s
    sequence.to_s
  end

  def next_code
    last_code.succ
  end

  protected

  def set_code
    self.sequence = next_code
  end

  def last_code
    self.class.where { self.contract_id.eq(contract_id) }.maximum(:sequence).to_i
  end

end
