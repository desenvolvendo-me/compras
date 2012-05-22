class LicitationProcessPublication < ActiveRecord::Base
  attr_accessible :licitation_process_id, :name, :publication_date, :publication_of, :circulation_type

  has_enumeration_for :publication_of, :with => PublicationOf, :create_helpers => true
  has_enumeration_for :circulation_type, :with => PublicationCirculationType

  belongs_to :licitation_process

  validates :name, :publication_date, :publication_of, :circulation_type, :presence => true

  def self.current
    where{ publication_date.lteq(Date.current) }.order{ publication_date }.last
  end

  def self.current_updatable?
    publication = current
    return true if publication.nil?

    publication.updatable?
  end

  def updatable?
    extension? || edital? || edital_rectification?
  end
end
