class MigrateMovimentTypeOperation < ActiveRecord::Migration
  class MovimentType < Compras::Model; end

  def change
    MovimentType.where(:operation => 'sum').update_all(:operation => 'add')
    MovimentType.where(:operation => 'subtraction').update_all(:operation => 'subtract')
  end
end
