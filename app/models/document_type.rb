class DocumentType < Unico::DocumentType
  attr_accessible :validity, :description, :habilitation_kind

  has_and_belongs_to_many :licitation_processes, :join_table => :compras_licitation_processes_unico_document_types

  def destroyable?
    licitation_processes.empty?
  end
end
