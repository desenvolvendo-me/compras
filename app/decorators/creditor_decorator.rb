class CreditorDecorator < Decorator
  attr_modal :person_id, :main_cnae_id

  def commercial_registration_date
    helpers.l super if super
  end
end
