class CreateJudgmentForms < ActiveRecord::Migration
  def change
    create_table :judgment_forms do |t|
      t.string :description
      t.string :kind
      t.string :licitation_kind

      t.timestamps
    end
  end
end
