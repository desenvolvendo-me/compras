class CreateFiscalActionsFiscalAgents < ActiveRecord::Migration
  def change
    create_table :fiscal_actions_fiscal_agents, :id => false do |t|
      t.references :fiscal_action
      t.references :fiscal_agent
    end

    add_index :fiscal_actions_fiscal_agents, :fiscal_action_id
    add_index :fiscal_actions_fiscal_agents, :fiscal_agent_id
    add_foreign_key :fiscal_actions_fiscal_agents, :fiscal_agents
    add_foreign_key :fiscal_actions_fiscal_agents, :fiscal_actions
  end
end
