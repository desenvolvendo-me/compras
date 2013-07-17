class RemoveRegistrationCadastralCertificate < ActiveRecord::Migration
  def change
    drop_table :compras_registration_cadastral_certificates
  end
end
