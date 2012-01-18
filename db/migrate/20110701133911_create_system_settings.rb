class CreateSystemSettings < ActiveRecord::Migration
  def change
    create_table :system_settings do |t|
      t.string :name
      t.string :year
      t.boolean :duplicate_cnpj_cpf, :default => false
      t.boolean :generate_automatic_registration_number, :default => false
      t.boolean :search_disable_records, :default => false

      t.timestamps
    end
  end
end
