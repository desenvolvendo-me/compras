# encoding: utf-8
class SupplyAuthorizationMailer < ActionMailer::Base
  add_template_helper ApplicationHelper

  def authorization_to_creditor(direct_purchase, prefecture)
    @direct_purchase = direct_purchase
    @prefecture = prefecture

    if prefecture.email.blank?
      mail :to => @direct_purchase.creditor_person_email, :subject => 'Autorização de Fornecimento'
    else
      mail :to => @direct_purchase.creditor_person_email, :subject => 'Autorização de Fornecimento', :from => prefecture.email
    end
  end
end
