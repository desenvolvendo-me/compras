class RenameAgrementIdsFromAgreementCancellations < ActiveRecord::Migration
  # rename column because agreement_ids is a field that has_many :agreements OVERRIDES :\
  def up
    rename_column :agreement_cancellations, :agreement_ids, :agreements_ids
  end

  def down
    rename_column :agreement_cancellations, :agreements_ids, :agreement_ids
  end
end
