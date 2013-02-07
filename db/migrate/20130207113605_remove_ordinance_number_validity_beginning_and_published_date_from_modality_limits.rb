class RemoveOrdinanceNumberValidityBeginningAndPublishedDateFromModalityLimits < ActiveRecord::Migration
  def change
    remove_column :compras_modality_limits, :validity_beginning
    remove_column :compras_modality_limits, :ordinance_number
    remove_column :compras_modality_limits, :published_date
  end
end
