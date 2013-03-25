# encoding: utf-8
ActiveRecord::Base.transaction do
  Customer.create!(:name => "Desenvolvimento", :domain => "0.0.0.0", :database => Customer.connection_config)

  user = User.create!(:name => "Compras e Licitações", :email => "compras-e-licitacoes@nobesistemas.com.br", :login => "compras", :password => "123456", :password_confirmation => "123456") do |user|
    user.administrator = true
  end

  user.confirm!
end

Dir[Rails.root.join("db/seeds/*.rb")].each do |file|
  require file
end
