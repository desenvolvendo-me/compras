class PersonPresenter < Presenter::Proxy
  attr_modal :name, :cpf, :cnpj
end
