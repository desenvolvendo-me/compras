class PersonDecorator < Decorator
  attr_modal :name, :cpf, :cnpj

  def commercial_registration_date
    helpers.l super if super
  end
end
