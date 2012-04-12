class PrefecturePresenter < Presenter::Proxy
  attr_modal :name, :cnpj, :phone, :fax, :email, :mayor_name
end
