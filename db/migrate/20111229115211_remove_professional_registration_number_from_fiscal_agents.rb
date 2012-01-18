class RemoveProfessionalRegistrationNumberFromFiscalAgents < ActiveRecord::Migration
  def change
    remove_column :fiscal_agents, :professional_registration_number
  end
end
