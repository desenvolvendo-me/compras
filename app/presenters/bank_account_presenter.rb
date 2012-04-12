class BankAccountPresenter < Presenter::Proxy
  attr_modal :name, :agency_id, :account_number, :originator, :number_agreement
end
