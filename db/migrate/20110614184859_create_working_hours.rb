class CreateWorkingHours < ActiveRecord::Migration
  def change
    create_table :working_hours do |t|
      t.string :name
      t.time :initial
      t.time :beginning_interval
      t.time :end_of_interval
      t.time :final

      t.timestamps
    end
  end
end
