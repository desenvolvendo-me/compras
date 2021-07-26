class AddOrganResponsibleForRegistrationToCreditors < ActiveRecord::Migration
  def change
    add_column :compras_creditors, :organ_responsible_for_registration, :string
  end
end
