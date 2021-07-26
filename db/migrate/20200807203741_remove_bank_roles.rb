class RemoveBankRoles < ActiveRecord::Migration
  def change
    Role.where("controller in ('banks','bank_accounts','agencies')").each do |role|
      role.update_column(:permission, "deny")
    end
  end
end
