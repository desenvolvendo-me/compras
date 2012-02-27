# encoding: utf-8
ActiveRecord::Base.transaction do
  User.create!(:name => "Compras e Licitações", :email => "compras-e-licitacoes@nobesistemas.com.br", :login => "compras", :password => "123456", :password_confirmation => "123456") do |user|
    user.administrator = true
  end
end

Dir['db/seeds/*.rb'].each do |file|
  require File.expand_path(file)
end
