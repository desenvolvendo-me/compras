class AddJudgmentFormToLicitationProcess < ActiveRecord::Migration
  def change
    add_column :licitation_processes, :judgment_form_id, :integer

    add_foreign_key :licitation_processes, :judgment_forms
    add_index :licitation_processes, :judgment_form_id
  end
end
