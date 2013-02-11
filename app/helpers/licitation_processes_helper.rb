# encoding: utf-8
module LicitationProcessesHelper
  def new_title
    "#{t("#{controller_name}.new", :resource => singular, :cascade => true)} no Processo Administrativo #{resource.administrative_process}"
  end

  def edit_title
    "Editar Processo Licitatório #{resource} do Processo Administrativo #{resource.administrative_process}"
  end

  def classification_link
    return unless resource.persisted?

    link_to('Relatório', licitation_process_path(resource), :class => "button secondary") unless resource.all_licitation_process_classifications.empty?
  end

  def calculation_link
    return unless resource.persisted?

    submit_tag('Apurar', :class => "button primary") if resource.has_bidders_and_is_available_for_classification
  end
end
