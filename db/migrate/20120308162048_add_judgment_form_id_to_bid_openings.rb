class AddJudgmentFormIdToBidOpenings < ActiveRecord::Migration
  def change
    add_column :bid_openings, :judgment_form_id, :integer
    add_index :bid_openings, :judgment_form_id
    add_foreign_key :bid_openings, :judgment_forms
  end
end
