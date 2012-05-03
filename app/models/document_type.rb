class DocumentType < ActiveRecord::Base
  attr_accessible :validity, :description

  has_and_belongs_to_many :licitation_processes

  has_many :provider_licitation_documents, :dependent => :restrict
  has_many :licitation_process_bidder_documents, :dependent => :restrict

  validates :validity, :description, :presence => true
  validates :description, :uniqueness => { :allow_blank => true }
  validates :validity, :numericality => { :allow_blank => true }

  orderize :description
  filterize

  def to_s
    description
  end
end
