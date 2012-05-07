class LicitationProcessPublication < ActiveRecord::Base
  attr_accessible :licitation_process_id, :name, :publication_date, :publication_of, :circulation_type

  has_enumeration_for :publication_of, :with => PublicationOf
  has_enumeration_for :circulation_type, :with => PublicationCirculationType

  belongs_to :licitation_process

  validates :name, :publication_date, :publication_of, :circulation_type, :presence => true

  def self.allow_update_licitation_process?(licitation_process_id)
    where { (self.licitation_process_id.eq licitation_process_id) &
            (publication_of.in [ PublicationOf::EXTENSION, PublicationOf::EDITAL, PublicationOf::EDITAL_RECTIFICATION ])
          }.any?
  end
end
