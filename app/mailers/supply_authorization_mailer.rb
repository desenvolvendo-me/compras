# encoding: utf-8
class SupplyAuthorizationMailer < ActionMailer::Base
  add_template_helper ApplicationHelper

  def authorization_to_creditor(direct_purchase, prefecture)
    @direct_purchase = direct_purchase
    @prefecture = prefecture

    mail :to => @direct_purchase.creditor_person_email, :subject => 'Autorização de Fornecimento', :from => email
  end

  def email
    @prefecture.email.blank? ? ActionMailer::Base.default[:from] : @prefecture.email
  end
end
