class AddTechnicalScoreToLicitationProcessBidder < ActiveRecord::Migration
  def up
    add_column :licitation_process_bidders, :technical_score, :decimal, :precision => 5, :scale => 2
  end

  def down
    remove_column :licitation_process_bidders, :technical_score
  end
end
