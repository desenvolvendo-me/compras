module OccurrenceContractualHistoricsHelper
  def new_title
    "Criar nova ocorrĂȘncia para o contrato #{resource.contract}"
  end

  def edit_title
    "Editar OcorrĂȘncia Contratual #{resource} do Contrato #{resource.contract}"
  end
end
