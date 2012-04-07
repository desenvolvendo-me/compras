class UpdateMovimentTypesSubtractionOperation < ActiveRecord::Migration
  def up
    MovimentType.where(:operation => 'subtration').update_all(:operation => 'subtraction')
  end

  def down
    MovimentType.where(:operation => 'subtraction').update_all(:operation => 'subtration')
  end
end
