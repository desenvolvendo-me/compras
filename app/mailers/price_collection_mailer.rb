# encoding: UTF-8

class PriceCollectionMailer < ActionMailer::Base
  def invite_new_creditor(user, price_collection)
    @user = user
    @price_collection = price_collection

    mail :to => @user.email, :subject => "Convite para o Registro de Preço #{ @price_collection }"
  end
end
