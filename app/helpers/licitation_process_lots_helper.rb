# encoding: utf-8

module LicitationProcessLotsHelper
  def new_title
    "#{t("#{controller_name}.new", :resource => singular, :cascade => true)} no Processo de Compra #{resource.licitation_process}"
  end

  def edit_title
    "Editar #{resource} do Processo de Compra #{resource.licitation_process}"
  end
end
