class ChangeModalityLimitsValidityBeginningToDate < ActiveRecord::Migration
  def up
    rename_column :modality_limits, :validity_beginning, :validity_beginning_string
    add_column :modality_limits, :validity_beginning, :date

    ModalityLimit.reset_column_information
    ModalityLimit.find(:all).each { |modality_limit| modality_limit.update_attribute(:validity_beginning, modality_limit.validity_beginning_string) }
    remove_column :modality_limits, :validity_beginning_string

  end

  def down
    change_column :modality_limits, :validity_beginning, :string
  end
end
