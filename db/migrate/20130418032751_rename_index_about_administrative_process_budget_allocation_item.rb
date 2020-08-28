class RenameIndexAboutAdministrativeProcessBudgetAllocationItem < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER INDEX compras_administrative_process_budget_allocation_items_pkey RENAME TO compras_purchase_process_items_pkey;
      ALTER INDEX clpbp_administrative_process_budget_allocation_item_id      RENAME TO clpbp_purchase_process_item_id;
      ALTER INDEX crpi_administrative_process_budget_allocation_item_id       RENAME TO crpi_purchase_process_item_id;
      ALTER INDEX index_purc_proc_cred_prop_on_admi_proc_budg_allo_item_id    RENAME TO index_purc_proc_cred_prop_on_pur_pro_item_id;
    SQL
  end

  def down
    execute <<-SQL
      ALTER INDEX compras_purchase_process_items_pkey           RENAME TO compras_administrative_process_budget_allocation_items_pkey;
      ALTER INDEX clpbp_purchase_process_item_id                RENAME TO clpbp_administrative_process_budget_allocation_item_id;
      ALTER INDEX crpi_purchase_process_item_id                 RENAME TO crpi_administrative_process_budget_allocation_item_id;
      ALTER INDEX index_purc_proc_cred_prop_on_pur_pro_item_id  RENAME TO index_purc_proc_cred_prop_on_admi_proc_budg_allo_item_id;
    SQL
  end
end
