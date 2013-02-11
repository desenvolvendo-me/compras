# encoding: utf-8
module PurchaseSolicitationLiberationsHelper
  def new_title(parent = @parent)
    "Criar Liberação para a Solicitação de Compra #{parent}"
  end

  def edit_title
    "Editar Liberação #{resource} da Solicitação de Compra #{resource.purchase_solicitation}"
  end
end
