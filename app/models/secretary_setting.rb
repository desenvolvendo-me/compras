class SecretarySetting < Compras::Model
  attr_accessible :secretary_id, :employee_id, :digital_signature, :signature,
                  :authorization_value, :active, :start_date, :end_date, :concierge, :active

  belongs_to :secretary
  belongs_to :employee

  orderize "id DESC"

  def self.was_persisted secretary_id
    self.find_by_secretary_id(secretary_id)
  end

  def self.build_secretary_settings secretary_id
    @secretary_setting = SecretarySetting.new
    @secretary_setting.secretary_id = secretary_id
    @secretary_setting.employee = @secretary_setting.secretary.employee

    @secretary_setting
  end

end