module ProcessResponsiblesHelper
  def link_create_or_edit(purchase_process)
    if purchase_process.process_responsibles.empty?
      "Cadastrar responsável"
    else
      purchase_process.process_responsibles.map{|x| x.name.try(:downcase)}.uniq.join(', ')
    end
  end

  def edit_title
    "Editar responsável do Processo de Compras"
  end
end
