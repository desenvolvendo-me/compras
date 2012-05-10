class AddPrecisionAndScaleToSubpledgeCancellationsValue < ActiveRecord::Migration
  def change
    change_column :subpledge_cancellations, :value, :decimal, :precision => 10, :scale => 2
  end
end
