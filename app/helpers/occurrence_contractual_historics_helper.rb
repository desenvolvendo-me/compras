# encoding:utf-8
module OccurrenceContractualHistoricsHelper
  def new_title
    "Criar nova ocorrência para o contrato #{resource.contract}"
  end

  def edit_title
    "Editar Ocorrência Contratual #{resource} do Contrato #{resource.contract}"
  end
end
