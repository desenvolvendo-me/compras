class CreateFiscalAgentsFiscalProgrammings < ActiveRecord::Migration
  def change
    create_table :fiscal_agents_fiscal_programmings, :id => false do |t|
      t.integer :fiscal_agent_id
      t.integer :fiscal_programming_id
    end

    add_index :fiscal_agents_fiscal_programmings, :fiscal_agent_id
    add_index :fiscal_agents_fiscal_programmings, :fiscal_programming_id, :name => 'idx_fiscal_programming_id'

    add_foreign_key :fiscal_agents_fiscal_programmings, :fiscal_agents
    add_foreign_key :fiscal_agents_fiscal_programmings, :fiscal_programmings, :name => 'fk_fiscal_programming_id'
  end
end
