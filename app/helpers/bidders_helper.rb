# encoding: utf-8

module BiddersHelper
  def new_title
    "#{t("#{controller_name}.new", :resource => singular, :cascade => true)} no Processo Licitatório #{resource.licitation_process}"
  end

  def edit_title
    "#{t("#{controller_name}.edit", :resource => singular, :cascade => true)} (#{resource}) do Processo Licitatório #{resource.licitation_process}"
  end
end
