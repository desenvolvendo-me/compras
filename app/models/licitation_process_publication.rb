class LicitationProcessPublication < Compras::Model
  attr_accessible :licitation_process_id, :name, :publication_date, :publication_of, :circulation_type

  has_enumeration_for :publication_of, :with => PublicationOf,
                      :create_helpers => true, :create_scopes => true
  has_enumeration_for :circulation_type, :with => PublicationCirculationType,
                      create_scopes: true

  belongs_to :licitation_process

  validates :name, :publication_date, :publication_of, :circulation_type, :presence => true
  validate  :block_edital
  validate  :publication_before_envelope_opening, :if => :edital?

  orderize :publication_date
  filterize

  def self.current
    where { publication_date.lteq(Date.current) }.order { publication_date }.last
  end

  def self.current_updateable?
    current.nil? || current.updatable?
  end

  def to_s
    name
  end

  def updatable?
    extension? || edital? || edital_rectification?
  end

  def publication_before_envelope_opening
    return unless licitation_process && licitation_process.proposal_envelope_opening_date

    if publication_date >= licitation_process.proposal_envelope_opening_date
      errors.add(:publication_date, :should_be_prior_to_envelope_opening)
    end
  end

  private

  def block_edital
    return unless licitation_process && direct_purchase_and_edital?

    errors.add(:publication_of, :invalid)
  end

  def direct_purchase_and_edital?
    licitation_process.simplified_processes? && edital?
  end
end
