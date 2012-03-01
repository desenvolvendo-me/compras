class DocumentType < ActiveRecord::Base
  attr_accessible :validity, :description

  has_many :provider_licitation_documents, :dependent => :restrict

  validates :validity, :description, :presence => true
  validates :description, :uniqueness => true
  validates :validity, :numericality => true

  orderize :description
  filterize

  def to_s
    description
  end
end
