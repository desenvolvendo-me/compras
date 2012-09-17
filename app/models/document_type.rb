class DocumentType < Compras::Model
  attr_accessible :validity, :description

  has_and_belongs_to_many :licitation_processes, :join_table => :compras_document_types_compras_licitation_processes

  has_many :bidder_documents, :dependent => :restrict

  validates :validity, :description, :presence => true
  validates :description, :uniqueness => { :allow_blank => true }
  validates :validity, :numericality => { :allow_blank => true }

  before_destroy :validate_licitation_process_relationship

  orderize :description
  filterize

  def to_s
    description
  end

  protected

  def validate_licitation_process_relationship
    return unless licitation_processes.any?

    errors.add(:base, :cant_be_destroyed)

    false
  end
end
