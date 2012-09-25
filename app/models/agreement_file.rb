class AgreementFile < Compras::Model
  attr_accessible :name, :file

  belongs_to :agreement

  validates :name, :file, :presence => true

  mount_uploader :file, DocumentUploader
end
