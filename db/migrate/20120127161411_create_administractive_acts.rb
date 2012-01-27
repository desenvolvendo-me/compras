class CreateAdministractiveActs < ActiveRecord::Migration
  def change
    create_table :administractive_acts do |t|
      t.string :act_number
      t.references :type_of_administractive_act
      t.string :text_legal_nature
      t.date :creation_date
      t.date :publication_date
      t.date :vigor_date
      t.date :end_date
      t.text :content
      t.decimal :budget_law_percent, :precision => 10, :scale => 2
      t.decimal :revenue_antecipation_percent, :precision => 10, :scale => 2
      t.decimal :authorized_debt_value, :precision => 10, :scale => 2

      t.timestamps
    end

    add_index :administractive_acts, :type_of_administractive_act_id
    add_foreign_key :administractive_acts, :type_of_administractive_acts
  end
end
