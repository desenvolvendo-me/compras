# encoding: utf-8

module ContractTerminationsHelper
  def new_title
    "Criar nova Rescisão Contratual para Contrato #{resource.contract}"
  end

  def edit_title
    "Editar Rescisão #{resource} do Contrato #{resource.contract}"
  end
end
