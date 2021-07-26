class AddSequenceToComprasLicitationProcessRatification < ActiveRecord::Migration
  def change
    add_column :compras_licitation_process_ratifications, :sequence, :integer
  end
end
