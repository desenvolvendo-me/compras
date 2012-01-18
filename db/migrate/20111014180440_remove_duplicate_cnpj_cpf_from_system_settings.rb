class RemoveDuplicateCnpjCpfFromSystemSettings < ActiveRecord::Migration
  def change
    remove_column :system_settings, :duplicate_cnpj_cpf
  end
end
