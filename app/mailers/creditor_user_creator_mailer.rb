# encoding: UTF-8

class CreditorUserCreatorMailer < ActionMailer::Base
  def price_collection_invite(user, price_collection)
    @user = user
    @price_collection = price_collection

    mail :to => @user.email, :subject => "Convite para o Registro de Preço #{ @price_collection }"
  end
end