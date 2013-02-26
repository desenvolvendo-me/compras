class LicitationProcessPublication < Compras::Model
  attr_accessible :licitation_process_id, :name, :publication_date, :publication_of, :circulation_type

  has_enumeration_for :publication_of, :with => PublicationOf,
                      :create_helpers => true, :create_scopes => true
  has_enumeration_for :circulation_type, :with => PublicationCirculationType

  belongs_to :licitation_process

  validates :name, :publication_date, :publication_of, :circulation_type, :presence => true
  validate  :publication_before_envelope_opening, :if => :edital?

  orderize :publication_date
  filterize

  def to_s
    name
  end

  def self.current
    where { publication_date.lteq(Date.current) }.order { publication_date }.last
  end

  def self.current_updatable?
    current.nil? || current.updatable?
  end

  def updatable?
    extension? || edital? || edital_rectification?
  end

  def publication_before_envelope_opening
    return unless licitation_process && licitation_process.envelope_opening_date

    if publication_date >= licitation_process.envelope_opening_date
      errors.add(:publication_date, :should_be_prior_to_envelope_opening)
    end
  end
end
