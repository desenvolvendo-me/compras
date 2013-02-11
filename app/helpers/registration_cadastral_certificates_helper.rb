# encoding: utf-8
module RegistrationCadastralCertificatesHelper
  def new_title
    "#{t("#{controller_name}.new", :resource => singular, :cascade => true)} para o Credor #{resource.creditor}"
  end

  def edit_title
    "#{t("#{controller_name}.edit", :resource => "#{singular} #{resource.to_s}", :cascade => true)} do Credor #{resource.creditor}"
  end
end
