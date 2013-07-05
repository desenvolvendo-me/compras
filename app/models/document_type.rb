class DocumentType < Compras::Model
  attr_accessible :validity, :description, :habilitation_kind

  has_enumeration_for :habilitation_kind

  has_and_belongs_to_many :licitation_processes, :join_table => :compras_document_types_compras_licitation_processes

  has_many :bidder_documents, :dependent => :restrict

  validates :validity, :description, :presence => true
  validates :description, :uniqueness => { :allow_blank => true }
  validates :validity, :numericality => { :allow_blank => true }

  orderize :description
  filterize

  def to_s
    description
  end

  def destroyable?
    licitation_processes.empty?
  end
end
