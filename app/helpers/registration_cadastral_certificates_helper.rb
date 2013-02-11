# encoding: utf-8
module RegistrationCadastralCertificatesHelper
  def edit_title
    "#{t("#{controller_name}.edit", :resource => "#{singular} #{resource.to_s}", :cascade => true)} do Credor #{resource.creditor}"
  end
end
