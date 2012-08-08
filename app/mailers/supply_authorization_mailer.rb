# encoding: utf-8
class SupplyAuthorizationMailer < ActionMailer::Base
  add_template_helper ApplicationHelper

  def authorization_to_creditor(direct_purchase)
    @direct_purchase = direct_purchase

    mail :to => @direct_purchase.creditor_person_email, :subject => 'Autorização de Fornecimento'
  end
end
