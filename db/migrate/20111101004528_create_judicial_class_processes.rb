class CreateJudicialClassProcesses < ActiveRecord::Migration
  def change
    create_table :judicial_class_processes do |t|
      t.string :name
      t.string :judicial_code

      t.timestamps
    end
  end
end
