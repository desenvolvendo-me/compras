class LicitationProcessPublication < Compras::Model
  attr_accessible :licitation_process_id, :name, :publication_date, :publication_of, :circulation_type

  has_enumeration_for :publication_of, :with => PublicationOf,
                      :create_helpers => true, :create_scopes => true
  has_enumeration_for :circulation_type, :with => PublicationCirculationType

  belongs_to :licitation_process

  validates :name, :publication_date, :publication_of, :circulation_type, :presence => true

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
end
