class IndividualPresenter < Presenter::Proxy
  attr_modal :person, :mother, :father, :birthdate, :gender, :cpf

  attr_data 'cpf' => :cpf
end
