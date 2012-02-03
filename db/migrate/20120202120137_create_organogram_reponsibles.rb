class CreateOrganogramReponsibles < ActiveRecord::Migration
  def change
    create_table :organogram_responsibles do |t|
      t.references :organogram
      t.references :responsible
      t.references :administractive_act
      t.date :start_date
      t.date :end_date
      t.string :status
    end

    add_foreign_key :organogram_responsibles, :organograms
    add_foreign_key :organogram_responsibles, :employees, :column => :responsible_id
    add_foreign_key :organogram_responsibles, :administractive_acts

    add_index :organogram_responsibles, :organogram_id
    add_index :organogram_responsibles, :responsible_id
    add_index :organogram_responsibles, :administractive_act_id
  end
end
