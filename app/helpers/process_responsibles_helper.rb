#encoding: utf-8
module ProcessResponsiblesHelper
  def link_create_or_edit(purchase_process)
    if purchase_process.process_responsibles.empty?
      "Criar responsável"
    else
      "Editar responsável"
    end
  end

  def edit_title
    "Editar responsável do Processo de Compras"
  end
end
