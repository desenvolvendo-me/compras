# encoding: utf-8

module JudgmentCommissionAdvicesHelper
  def new_title
    "#{t("#{controller_name}.new", :resource => singular, :cascade => true)} para o Processo Licitatório #{resource.licitation_process}"
  end

  def edit_title
    "Editar Parecer da Comissão Julgadora #{resource} do Processo Licitatório #{resource.licitation_process}"
  end
end
