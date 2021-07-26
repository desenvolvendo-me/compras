module LicitationProcessPublicationsHelper
  def new_title
    "#{t("#{controller_name}.new", :resource => singular, :cascade => true)} para o Processo de Compra #{resource.licitation_process}"
  end

  def edit_title
    "Editar Publicação #{resource} do Processo de Compra #{resource.licitation_process}"
  end

  def publication_of_collection(licitation_process)
    if licitation_process.simplified_processes?
      PublicationOf.allowed_for_direct_purchase
    else
      PublicationOf.to_a.sort { |a,b| a[0] <=> b[0] }
    end
  end
end
