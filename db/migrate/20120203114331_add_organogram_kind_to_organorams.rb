class AddOrganogramKindToOrganorams < ActiveRecord::Migration
  def change
    add_column :organograms, :organogram_kind, :string
  end
end
