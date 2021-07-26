class PriceCollectionMailer < ActionMailer::Base
  helper ApplicationHelper

  def invite_new_creditor(user, price_collection)
    @user = user
    @price_collection = price_collection

    mail :to => @user.email, :subject => "Convite para o Registro de Preço #{ @price_collection }"
  end

  def invite_registered_creditor(creditor, price_collection, current_prefecture, customer)
    @creditor = creditor
    @price_collection = price_collection
    @prefecture = current_prefecture
    @customer = customer

    mail :to => @creditor.email, :subject => "Convite para o Registro de Preço #{ @price_collection }"
  end
end
