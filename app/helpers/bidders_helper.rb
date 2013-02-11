# encoding: utf-8

module BiddersHelper
  def edit_title
    "#{t("#{controller_name}.edit", :resource => singular, :cascade => true)} (#{resource}) do Processo Licitatório #{resource.licitation_process}"
  end
end
