class MigrateAccounting < ActiveRecord::Migration
  def change
    if Rails.env.development? || Rails.env.test?
      create_table "accounting_government_programs" do |t|
        t.string   "description"
        t.string   "status"
        t.datetime "created_at", :null => false
        t.datetime "updated_at", :null => false
        t.integer  "descriptor_id"
        t.string   "code"
        t.integer  "program_kind_id"
        t.string   "title"
        t.integer  "macro_objective_id"
        t.integer  "budget_structure_id"
        t.integer  "person_id"
        t.string   "time_span"
        t.date     "start_date"
        t.date     "end_date"
        t.string   "goal"
        t.string   "justification"
        t.string   "implementation_strategy"
        t.integer  "year"
        t.integer  "entity_id"
      end

      create_table "accounting_government_actions" do |t|
        t.string   "description"
        t.datetime "created_at",            :null => false
        t.datetime "updated_at",            :null => false
        t.integer  "descriptor_id"
        t.string   "code"
        t.integer  "action_type"
        t.string   "budget_type"
        t.integer  "reference_unit_id"
        t.string   "title"
        t.integer  "product_id"
        t.string   "goal"
        t.string   "legal_basis"
        t.string   "implementation_method"
        t.date     "start_date"
        t.date     "end_date"
      end

      create_table "accounting_expense_natures" do |t|
        t.integer  "regulatory_act_id"
        t.string   "expense_nature"
        t.string   "kind"
        t.string   "description"
        t.text     "docket"
        t.datetime "created_at",        :null => false
        t.datetime "updated_at",        :null => false
        t.integer  "year"
        t.integer  "parent_id"
      end

      create_table "accounting_budget_allocations" do |t|
        t.datetime "created_at",                                                                  :null => false
        t.datetime "updated_at",                                                                  :null => false
        t.decimal  "amount",                    :precision => 10, :scale => 2, :default => 0.0,   :null => false
        t.integer  "budget_structure_id"
        t.integer  "subfunction_id"
        t.integer  "government_program_id"
        t.integer  "government_action_id"
        t.integer  "expense_nature_id"
        t.integer  "capability_id"
        t.string   "debt_type"
        t.integer  "budget_allocation_type_id"
        t.boolean  "refinancing",                                              :default => false
        t.boolean  "health",                                                   :default => false
        t.boolean  "alienation_appeal",                                        :default => false
        t.boolean  "education",                                                :default => false
        t.boolean  "foresight",                                                :default => false
        t.boolean  "personal",                                                 :default => false
        t.date     "date"
        t.decimal  "value",                     :precision => 10, :scale => 2
        t.string   "kind"
        t.integer  "code"
        t.integer  "descriptor_id"
        t.integer  "function_id"
        t.text     "months_values"
        t.integer  "year"
      end

      create_table "accounting_budget_structures" do |t|
        t.integer  "budget_structure_configuration_id"
        t.string   "tce_code"
        t.string   "description"
        t.string   "acronym"
        t.text     "performance_field"
        t.datetime "created_at",                        :null => false
        t.datetime "updated_at",                        :null => false
        t.string   "kind"
        t.integer  "administration_type_id"
        t.string   "code"
        t.integer  "budget_structure_level_id"
        t.integer  "parent_id"
        t.hstore   "custom_data"
        t.string   "full_code"
      end

      create_table "accounting_functions" do |t|
        t.string   "code"
        t.integer  "regulatory_act_id"
        t.string   "description"
        t.datetime "created_at",        :null => false
        t.datetime "updated_at",        :null => false
        t.integer  "year"
      end

      create_table "accounting_subfunctions" do |t|
        t.string   "code"
        t.string   "description"
        t.datetime "created_at",    :null => false
        t.datetime "updated_at",    :null => false
        t.integer  "year"
        t.integer  "entity_id"
      end

      create_table "accounting_budget_structure_configurations" do |t|
        t.integer  "entity_id"
        t.integer  "regulatory_act_id"
        t.string   "description"
        t.datetime "created_at",        :null => false
        t.datetime "updated_at",        :null => false
        t.integer "year"
      end

      create_table "accounting_budget_structure_levels" do |t|
        t.integer  "budget_structure_configuration_id"
        t.integer  "level"
        t.string   "description"
        t.integer  "digits"
        t.string   "separator"
        t.datetime "created_at",                                           :null => false
        t.datetime "updated_at",                                           :null => false
        t.boolean  "analytic",                          :default => false
        t.boolean  "budgetary",                         :default => false
        t.hstore   "custom_data"
      end

      create_table "accounting_budget_structure_responsibles" do |t|
        t.integer "budget_structure_id"
        t.integer "responsible_id"
        t.integer "regulatory_act_id"
        t.date    "start_date"
        t.date    "end_date"
        t.hstore  "custom_data"
      end

      create_table "accounting_capabilities" do |t|
        t.string   "description"
        t.text     "goal"
        t.string   "kind"
        t.datetime "created_at",                      :null => false
        t.datetime "updated_at",                      :null => false
        t.string   "status"
        t.string   "source"
        t.integer  "descriptor_id"
        t.integer  "capability_destination_id"
        t.integer  "tce_specification_capability_id"
        t.integer  "entity_id"
        t.integer  "year"
      end

      create_table "accounting_descriptors" do |t|
        t.integer  "entity_id"
        t.datetime "created_at", :null => false
        t.datetime "updated_at", :null => false
        t.date     "period"
        t.integer  "year"
      end

      create_table "accounting_budget_allocation_capabilities" do |t|
        t.integer  "budget_allocation_id"
        t.integer  "capability_id"
        t.decimal  "amount",               :precision => 10, :scale => 2, :default => 0.0, :null => false
        t.datetime "created_at",                                                           :null => false
        t.datetime "updated_at",                                                           :null => false
      end

      create_table "accounting_reserve_funds" do |t|
        t.integer  "budget_allocation_id"
        t.decimal  "value",                      :precision => 10, :scale => 2
        t.datetime "created_at",                                                :null => false
        t.datetime "updated_at",                                                :null => false
        t.integer  "reserve_allocation_type_id"
        t.string   "status"
        t.date     "date"
        t.text     "reason"
        t.integer  "creditor_id"
        t.integer  "descriptor_id"
        t.integer  "licitation_process_id"
        t.integer  "modality"
        t.string   "licitation_process"
      end

      create_table "accounting_pledges" do |t|
        t.integer  "management_unit_id"
        t.date     "emission_date"
        t.integer  "budget_allocation_id"
        t.decimal  "value",                    :precision => 10, :scale => 2
        t.integer  "pledge_category_id"
        t.datetime "created_at",                                              :null => false
        t.datetime "updated_at",                                              :null => false
        t.integer  "expense_kind_id"
        t.integer  "accounting_historic_id"
        t.integer  "contract_id"
        t.text     "description"
        t.integer  "reserve_fund_id"
        t.string   "material_kind"
        t.integer  "founded_debt_contract_id"
        t.string   "pledge_modality"
        t.integer  "licitation_process_id"
        t.integer  "code"
        t.integer  "creditor_id"
        t.integer  "expense_nature_id"
        t.integer  "descriptor_id"
        t.integer  "precatory_id"
        t.integer  "modality"
        t.integer  "special_inscription_id"
        t.hstore   "custom_data"
        t.string   "licitation_process"
        t.integer  "licitation_process_year"
        t.integer  "capability_id"
        t.integer  "main_pledge_id"
        t.boolean  "leftover_pledge"
        t.integer  "year"
        t.decimal  "initial_value_not_processed",  :precision => 10, :scale => 2
        t.decimal  "initial_value_processed",  :precision => 10, :scale => 2
        t.text     "historic_complement"
      end
    end

    remove_foreign_key :compras_purchase_process_budget_allocations, name: :adm_proc_bdgt_alloc_budget_allocation_fk
    remove_foreign_key :compras_purchase_process_budget_allocations, name: :adm_proc_budget_alloc_expense_nature_fk
    remove_foreign_key :compras_purchase_process_budget_allocations, name: :apba_budget_allocation_fk
    remove_foreign_key :compras_direct_purchase_budget_allocations, name: :dpba_budget_allocation_fk
    remove_foreign_key :compras_purchase_solicitation_budget_allocations, name: :cpsba_expense_nature_fk
    remove_foreign_key :compras_purchase_solicitation_budget_allocations, name: :psba_budget_allocation_fk
    remove_foreign_key :compras_materials, name: :materials_economic_classification_of_expenditure_id_fk
    remove_foreign_key :compras_contracts, name: :compras_contracts_budget_structure_id_fk
    remove_foreign_key :compras_purchase_solicitations, name: :purchase_solicitations_organogram_id_fk
    remove_foreign_key :compras_direct_purchases, name: :direct_purchases_organogram_id_fk
    remove_foreign_key :compras_bank_account_capabilities, name: :cbar_cc_fk
    remove_foreign_key :compras_management_units, name: :compras_management_units_descriptor_id_fk
  end
end
