class IndividualDecorator < Decorator
  attr_modal :person, :mother, :father, :birthdate, :gender, :cpf

  attr_data 'cpf' => :cpf
end
