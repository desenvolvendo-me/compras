class CreateAllForeignKeys < ActiveRecord::Migration
  def change
    #add_foreign_key "accountants", "unico_people", :name => "accountants_person_id_fk", :column => "person_id"

    #add_foreign_key "active_debts", "compras_currencies", :name => "active_debts_converted_currency_id_fk", :column => "converted_currency_id"
    #add_foreign_key "active_debts", "compras_currencies", :name => "active_debts_original_currency_id_fk", :column => "original_currency_id"

    #add_foreign_key "activity_economic_registrations", "compras_economic_registrations", :name => "activity_economic_registrations_economic_registrations_fk", :column => "economic_registration_id"

    #add_foreign_key "bank_accounts_revenues", "compras_bank_accounts", :name => "bank_accounts_revenues_bank_account_id_fk", :column => "bank_account_id"

    #add_foreign_key "branch_activities", "compras_cnaes", :name => "branch_activities_cnae_id_fk", :column => "cnae_id"

    add_foreign_key "compras_accredited_representatives", "compras_licitation_process_bidders", :name => "ar_licitation_process_bidder_fk", :column => "licitation_process_bidder_id"
    add_foreign_key "compras_accredited_representatives", "unico_people", :name => "accredited_representatives_person_id_fk", :column => "person_id"

    add_foreign_key "compras_administration_types", "unico_legal_natures", :name => "administration_types_legal_nature_id_fk", :column => "legal_nature_id"

    add_foreign_key "compras_administrative_process_budget_allocation_items", "compras_administrative_process_budget_allocations", :name => "apbai_administrative_process_budget_allocation_fk", :column => "administrative_process_budget_allocation_id"
    add_foreign_key "compras_administrative_process_budget_allocation_items", "compras_licitation_process_lots", :name => "apbai_licitation_process_lot_fk", :column => "licitation_process_lot_id"
    add_foreign_key "compras_administrative_process_budget_allocation_items", "compras_materials", :name => "apbai_material_fk", :column => "material_id"

    add_foreign_key "compras_administrative_process_budget_allocations", "compras_administrative_processes", :name => "apba_administrative_process_fk", :column => "administrative_process_id"
    add_foreign_key "compras_administrative_process_budget_allocations", "compras_budget_allocations", :name => "apba_budget_allocation_fk", :column => "budget_allocation_id"

    add_foreign_key "compras_administrative_processes", "compras_employees", :name => "bid_openings_responsible_id_fk", :column => "responsible_id"
    add_foreign_key "compras_administrative_processes", "compras_judgment_forms", :name => "bid_openings_judgment_form_id_fk", :column => "judgment_form_id"

    add_foreign_key "compras_agencies", "compras_banks", :name => "agencies_bank_id_fk", :column => "bank_id"
    add_foreign_key "compras_agencies", "unico_cities", :name => "agencies_city_id_fk", :column => "city_id"

    add_foreign_key "compras_bank_accounts", "compras_agencies", :name => "bank_accounts_agency_id_fk", :column => "agency_id"

    add_foreign_key "compras_bookmarks", "compras_users", :name => "bookmarks_user_id_fk", :column => "user_id"

    add_foreign_key "compras_bookmarks_compras_links", "compras_bookmarks", :name => "bookmarks_links_bookmark_id_fk", :column => "bookmark_id"
    add_foreign_key "compras_bookmarks_compras_links", "compras_links", :name => "bookmarks_links_link_id_fk", :column => "link_id"

    add_foreign_key "compras_budget_allocations", "compras_budget_allocation_types", :name => "budget_allocations_budget_allocation_type_id_fk", :column => "budget_allocation_type_id"
    add_foreign_key "compras_budget_allocations", "compras_budget_structures", :name => "budget_allocations_organogram_id_fk", :column => "budget_structure_id"
    add_foreign_key "compras_budget_allocations", "compras_capabilities", :name => "budget_allocations_capability_id_fk", :column => "capability_id"
    add_foreign_key "compras_budget_allocations", "compras_entities", :name => "budget_allocations_entity_id_fk", :column => "entity_id"
    add_foreign_key "compras_budget_allocations", "compras_expense_natures", :name => "budget_allocations_expense_economic_classification_id_fk", :column => "expense_nature_id"
    add_foreign_key "compras_budget_allocations", "compras_government_actions", :name => "budget_allocations_government_action_id_fk", :column => "government_action_id"
    add_foreign_key "compras_budget_allocations", "compras_government_programs", :name => "budget_allocations_government_program_id_fk", :column => "government_program_id"
    add_foreign_key "compras_budget_allocations", "compras_subfunctions", :name => "budget_allocations_subfunction_id_fk", :column => "subfunction_id"

    add_foreign_key "compras_budget_structure_configurations", "compras_entities", :name => "configuration_organograms_entity_id_fk", :column => "entity_id"
    add_foreign_key "compras_budget_structure_configurations", "compras_regulatory_acts", :name => "configuration_organograms_administractive_act_id_fk", :column => "regulatory_act_id"

    add_foreign_key "compras_budget_structure_levels", "compras_budget_structure_configurations", :name => "organogram_levels_configuration_organogram_id_fk", :column => "budget_structure_configuration_id"

    add_foreign_key "compras_budget_structure_responsibles", "compras_budget_structures", :name => "organogram_responsibles_organogram_id_fk", :column => "budget_structure_id"
    add_foreign_key "compras_budget_structure_responsibles", "compras_employees", :name => "organogram_responsibles_responsible_id_fk", :column => "responsible_id"
    add_foreign_key "compras_budget_structure_responsibles", "compras_regulatory_acts", :name => "organogram_responsibles_administractive_act_id_fk", :column => "regulatory_act_id"

    add_foreign_key "compras_budget_structures", "compras_administration_types", :name => "organograms_administration_type_id_fk", :column => "administration_type_id"
    add_foreign_key "compras_budget_structures", "compras_budget_structure_configurations", :name => "organograms_configuration_organogram_id_fk", :column => "budget_structure_configuration_id"
    add_foreign_key "compras_budget_structures", "compras_budget_structure_levels", :name => "budget_structures_budget_structure_level_id_fk", :column => "budget_structure_level_id"
    add_foreign_key "compras_budget_structures", "compras_budget_structures", :name => "budget_structures_parent_id_fk", :column => "parent_id"

    add_foreign_key "compras_capabilities", "compras_entities", :name => "capabilities_entity_id_fk", :column => "entity_id"

    add_foreign_key "compras_cnaes", "compras_cnaes", :name => "cnaes_parent_id_fk", :column => "parent_id"
    add_foreign_key "compras_cnaes", "compras_risk_degrees", :name => "cnaes_risk_degree_id_fk", :column => "risk_degree_id"

    add_foreign_key "compras_contracts", "compras_entities", :name => "management_contracts_entity_id_fk", :column => "entity_id"

    add_foreign_key "compras_creditor_balances", "compras_creditors", :name => "creditor_balances_creditor_id_fk", :column => "creditor_id"

    add_foreign_key "compras_creditor_bank_accounts", "compras_agencies", :name => "creditor_bank_accounts_agency_id_fk", :column => "agency_id"
    add_foreign_key "compras_creditor_bank_accounts", "compras_creditors", :name => "creditor_bank_accounts_creditor_id_fk", :column => "creditor_id"

    add_foreign_key "compras_creditor_documents", "compras_creditors", :name => "creditor_documents_creditor_id_fk", :column => "creditor_id"
    add_foreign_key "compras_creditor_documents", "compras_document_types", :name => "creditor_documents_document_type_id_fk", :column => "document_type_id"

    add_foreign_key "compras_creditor_materials", "compras_creditors", :name => "creditor_materials_creditor_id_fk", :column => "creditor_id"
    add_foreign_key "compras_creditor_materials", "compras_materials", :name => "creditor_materials_material_id_fk", :column => "material_id"

    add_foreign_key "compras_creditor_representatives", "compras_creditors", :name => "creditor_representatives_creditor_id_fk", :column => "creditor_id"
    add_foreign_key "compras_creditor_representatives", "unico_people", :name => "creditor_representatives_representative_person_id_fk", :column => "representative_person_id"

    add_foreign_key "compras_creditor_secondary_cnaes", "compras_cnaes", :name => "creditor_secondary_cnaes_cnae_id_fk", :column => "cnae_id"
    add_foreign_key "compras_creditor_secondary_cnaes", "compras_creditors", :name => "creditor_secondary_cnaes_creditor_id_fk", :column => "creditor_id"

    add_foreign_key "compras_creditors", "compras_cnaes", :name => "creditors_main_cnae_id_fk", :column => "main_cnae_id"
    add_foreign_key "compras_creditors", "compras_occupation_classifications", :name => "creditors_occupation_classification_id_fk", :column => "occupation_classification_id"
    add_foreign_key "compras_creditors", "unico_people", :name => "creditors_person_id_fk", :column => "person_id"
    add_foreign_key "compras_creditors", "unico_company_sizes", :name => "creditors_company_size_id_fk", :column => "company_size_id"

    add_foreign_key "compras_delivery_locations", "unico_addresses", :name => "delivery_locations_address_id_fk", :column => "address_id"

    add_foreign_key "compras_direct_purchase_budget_allocation_items", "compras_direct_purchase_budget_allocations", :name => "dpbai_budget_allocation_fk", :column => "direct_purchase_budget_allocation_id"
    add_foreign_key "compras_direct_purchase_budget_allocation_items", "compras_materials", :name => "dpbai_material_fk", :column => "material_id"

    add_foreign_key "compras_direct_purchase_budget_allocations", "compras_budget_allocations", :name => "dpba_budget_allocation_fk", :column => "budget_allocation_id"
    add_foreign_key "compras_direct_purchase_budget_allocations", "compras_direct_purchases", :name => "dpba_direct_purchase_fk", :column => "direct_purchase_id"

    add_foreign_key "compras_direct_purchases", "compras_budget_structures", :name => "direct_purchases_organogram_id_fk", :column => "budget_structure_id"
    add_foreign_key "compras_direct_purchases", "compras_delivery_locations", :name => "direct_purchases_delivery_location_id_fk", :column => "delivery_location_id"
    add_foreign_key "compras_direct_purchases", "compras_employees", :name => "direct_purchases_employee_id_fk", :column => "employee_id"
    add_foreign_key "compras_direct_purchases", "compras_legal_references", :name => "direct_purchases_legal_reference_id_fk", :column => "legal_reference_id"
    add_foreign_key "compras_direct_purchases", "compras_licitation_objects", :name => "direct_purchases_licitation_object_id_fk", :column => "licitation_object_id"
    add_foreign_key "compras_direct_purchases", "compras_payment_methods", :name => "direct_purchases_payment_method_id_fk", :column => "payment_method_id"
    add_foreign_key "compras_direct_purchases", "compras_providers", :name => "direct_purchases_provider_id_fk", :column => "provider_id"

    add_foreign_key "compras_dissemination_sources", "compras_communication_sources", :name => "dissemination_sources_communication_source_id_fk", :column => "communication_source_id"

    add_foreign_key "compras_dissemination_sources_compras_regulatory_acts", "compras_dissemination_sources", :name => "aads_dissemination_source_id_fk", :column => "dissemination_source_id"
    add_foreign_key "compras_dissemination_sources_compras_regulatory_acts", "compras_regulatory_acts", :name => "aads_administractive_act_id_fk", :column => "regulatory_act_id"

    add_foreign_key "compras_document_types_compras_licitation_processes", "compras_document_types", :name => "dtlp_document_types_fk", :column => "document_type_id"
    add_foreign_key "compras_document_types_compras_licitation_processes", "compras_licitation_processes", :name => "dtlp_licitation_processes_fk", :column => "licitation_process_id"

    add_foreign_key "compras_economic_registrations", "unico_people", :name => "economic_registrations_person_id_fk", :column => "person_id"

    add_foreign_key "compras_employees", "unico_people", :name => "employees_person_id_fk", :column => "person_id"
    add_foreign_key "compras_employees", "compras_positions", :name => "employees_position_id_fk", :column => "position_id"

    add_foreign_key "compras_expense_natures", "compras_entities", :name => "economic_classification_of_expenditures_entity_id_fk", :column => "entity_id"
    add_foreign_key "compras_expense_natures", "compras_expense_categories", :name => "expense_natures_expense_category_id_fk", :column => "expense_category_id"
    add_foreign_key "compras_expense_natures", "compras_expense_elements", :name => "expense_natures_expense_element_id_fk", :column => "expense_element_id"
    add_foreign_key "compras_expense_natures", "compras_expense_groups", :name => "expense_natures_expense_group_id_fk", :column => "expense_group_id"
    add_foreign_key "compras_expense_natures", "compras_expense_modalities", :name => "expense_natures_expense_modality_id_fk", :column => "expense_modality_id"
    add_foreign_key "compras_expense_natures", "compras_regulatory_acts", :name => "ecoe_administractive_act_fk", :column => "regulatory_act_id"

    add_foreign_key "compras_extra_credit_moviment_types", "compras_budget_allocations", :name => "acomt_budget_allocation_id_fk", :column => "budget_allocation_id"
    add_foreign_key "compras_extra_credit_moviment_types", "compras_capabilities", :name => "acomt_capability_id_fk", :column => "capability_id"
    add_foreign_key "compras_extra_credit_moviment_types", "compras_extra_credits", :name => "acomt_aco_id_fk", :column => "extra_credit_id"
    add_foreign_key "compras_extra_credit_moviment_types", "compras_moviment_types", :name => "acomt_moviment_type_id_fk", :column => "moviment_type_id"

    add_foreign_key "compras_extra_credits", "compras_entities", :name => "additional_credit_openings_entity_id_fk", :column => "entity_id"
    add_foreign_key "compras_extra_credits", "compras_extra_credit_natures", :name => "aco_acon_id_fk", :column => "extra_credit_nature_id"
    add_foreign_key "compras_extra_credits", "compras_regulatory_acts", :name => "additional_credit_openings_administractive_act_id_fk", :column => "regulatory_act_id"

    add_foreign_key "compras_functions", "compras_regulatory_acts", :name => "functions_administractive_act_id_fk", :column => "regulatory_act_id"

    add_foreign_key "compras_government_actions", "compras_entities", :name => "government_actions_entity_id_fk", :column => "entity_id"

    add_foreign_key "compras_government_programs", "compras_entities", :name => "government_programs_entity_id_fk", :column => "entity_id"

    add_foreign_key "compras_indexer_values", "compras_indexers", :name => "indexer_values_indexer_id_fk", :column => "indexer_id"

    add_foreign_key "compras_indexers", "compras_currencies", :name => "indexers_currency_id_fk", :column => "currency_id"

    add_foreign_key "compras_judgment_commission_advice_members", "unico_individuals", :name => "jcam_individual_fk", :column => "individual_id"
    add_foreign_key "compras_judgment_commission_advice_members", "compras_judgment_commission_advices", :name => "jcam_judgment_commission_advice_fk", :column => "judgment_commission_advice_id"
    add_foreign_key "compras_judgment_commission_advice_members", "compras_licitation_commission_members", :name => "jcam_licitation_commission_member_fk", :column => "licitation_commission_member_id"

    add_foreign_key "compras_judgment_commission_advices", "compras_licitation_commissions", :name => "judgment_commission_advices_licitation_commission_id_fk", :column => "licitation_commission_id"
    add_foreign_key "compras_judgment_commission_advices", "compras_licitation_processes", :name => "judgment_commission_advices_licitation_process_id_fk", :column => "licitation_process_id"

    add_foreign_key "compras_licitation_commission_members", "unico_individuals", :name => "lcm_individual_fk", :column => "individual_id"
    add_foreign_key "compras_licitation_commission_members", "compras_licitation_commissions", :name => "lcm_licitation_commission_fk", :column => "licitation_commission_id"

    add_foreign_key "compras_licitation_commission_responsibles", "unico_individuals", :name => "lcr_individual_kf", :column => "individual_id"
    add_foreign_key "compras_licitation_commission_responsibles", "compras_licitation_commissions", :name => "lcr_licitation_commission_fk", :column => "licitation_commission_id"

    add_foreign_key "compras_licitation_commissions", "compras_regulatory_acts", :name => "licitation_commissions_regulatory_act_id_fk", :column => "regulatory_act_id"

    add_foreign_key "compras_licitation_modalities", "compras_regulatory_acts", :name => "licitation_modalities_administractive_act_id_fk", :column => "regulatory_act_id"

    add_foreign_key "compras_licitation_notices", "compras_licitation_processes", :name => "licitation_notices_licitation_process_id_fk", :column => "licitation_process_id"

    add_foreign_key "compras_licitation_objects_compras_materials", "compras_licitation_objects", :name => "licitation_objects_materials_licitation_object_id_fk", :column => "licitation_object_id"
    add_foreign_key "compras_licitation_objects_compras_materials", "compras_materials", :name => "licitation_objects_materials_material_id_fk", :column => "material_id"

    add_foreign_key "compras_licitation_process_appeals", "compras_licitation_processes", :name => "licitation_process_appeals_licitation_process_id_fk", :column => "licitation_process_id"
    add_foreign_key "compras_licitation_process_appeals", "unico_people", :name => "licitation_process_appeals_person_id_fk", :column => "person_id"

    add_foreign_key "compras_licitation_process_bidder_documents", "compras_document_types", :name => "lpvd_document_type_fk", :column => "document_type_id"
    add_foreign_key "compras_licitation_process_bidder_documents", "compras_licitation_process_bidders", :name => "lpvd_licitation_process_bidder_fk", :column => "licitation_process_bidder_id"

    add_foreign_key "compras_licitation_process_bidder_proposals", "compras_administrative_process_budget_allocation_items", :name => "administrative_process_budget_allocation_item_id_fk", :column => "administrative_process_budget_allocation_item_id"
    add_foreign_key "compras_licitation_process_bidder_proposals", "compras_licitation_process_bidders", :name => "licitation_process_bidder_id_fk", :column => "licitation_process_bidder_id"

    add_foreign_key "compras_licitation_process_bidders", "compras_licitation_processes", :name => "lpb_licitation_process_fk", :column => "licitation_process_id"
    add_foreign_key "compras_licitation_process_bidders", "compras_providers", :name => "lpb_provider_fk", :column => "provider_id"

    add_foreign_key "compras_licitation_process_impugnments", "compras_licitation_processes", :name => "licitation_process_impugnments_licitation_process_id_fk", :column => "licitation_process_id"
    add_foreign_key "compras_licitation_process_impugnments", "unico_people", :name => "licitation_process_impugnments_person_id_fk", :column => "person_id"

    add_foreign_key "compras_licitation_process_lots", "compras_licitation_processes", :name => "licitation_process_lots_licitation_process_id_fk", :column => "licitation_process_id"

    add_foreign_key "compras_licitation_process_publications", "compras_licitation_processes", :name => "licitation_process_publications_licitation_process_id_fk", :column => "licitation_process_id"

    add_foreign_key "compras_licitation_processes", "compras_administrative_processes", :name => "licitation_processes_bid_opening_id_fk", :column => "administrative_process_id"
    add_foreign_key "compras_licitation_processes", "compras_capabilities", :name => "licitation_processes_capability_id_fk", :column => "capability_id"
    add_foreign_key "compras_licitation_processes", "compras_indexers", :name => "licitation_processes_readjustment_index_id_fk", :column => "readjustment_index_id"
    add_foreign_key "compras_licitation_processes", "compras_judgment_forms", :name => "licitation_processes_judgment_form_id_fk", :column => "judgment_form_id"
    add_foreign_key "compras_licitation_processes", "compras_payment_methods", :name => "licitation_processes_payment_method_id_fk", :column => "payment_method_id"

    add_foreign_key "compras_management_units", "compras_entities", :name => "management_units_entity_id_fk", :column => "entity_id"

    add_foreign_key "compras_materials", "compras_expense_natures", :name => "materials_economic_classification_of_expenditure_id_fk", :column => "expense_nature_id"
    add_foreign_key "compras_materials", "compras_materials_classes", :name => "materials_materials_class_id_fk", :column => "materials_class_id"
    add_foreign_key "compras_materials", "compras_reference_units", :name => "materials_reference_unit_id_fk", :column => "reference_unit_id"
    add_foreign_key "compras_materials", "compras_service_or_contract_types", :name => "materials_service_or_contract_type_id_fk", :column => "service_or_contract_type_id"

    add_foreign_key "compras_materials_classes", "compras_materials_groups", :name => "materials_classes_materials_group_id_fk", :column => "materials_group_id"

    add_foreign_key "compras_materials_classes_compras_providers", "compras_materials_classes", :name => "materials_classes_providers_materials_class_id_fk", :column => "materials_class_id"
    add_foreign_key "compras_materials_classes_compras_providers", "compras_providers", :name => "materials_classes_providers_provider_id_fk", :column => "provider_id"

    add_foreign_key "compras_materials_compras_providers", "compras_materials", :name => "materials_providers_material_id_fk", :column => "material_id"
    add_foreign_key "compras_materials_compras_providers", "compras_providers", :name => "materials_providers_provider_id_fk", :column => "provider_id"

    add_foreign_key "compras_materials_groups_compras_providers", "compras_materials_groups", :name => "materials_groups_providers_materials_group_id_fk", :column => "materials_group_id"
    add_foreign_key "compras_materials_groups_compras_providers", "compras_providers", :name => "materials_groups_providers_provider_id_fk", :column => "provider_id"

    add_foreign_key "compras_occupation_classifications", "compras_occupation_classifications", :name => "occupation_classifications_parent_id_fk", :column => "parent_id"

    add_foreign_key "compras_pledge_cancellations", "compras_pledges", :name => "pledge_cancellations_pledge_id_fk", :column => "pledge_id"

    add_foreign_key "compras_pledge_historics", "compras_entities", :name => "pledge_historics_entity_id_fk", :column => "entity_id"

    add_foreign_key "compras_pledge_items", "compras_materials", :name => "pledge_items_material_id_fk", :column => "material_id"
    add_foreign_key "compras_pledge_items", "compras_pledges", :name => "pledge_items_pledge_id_fk", :column => "pledge_id"

    add_foreign_key "compras_pledge_liquidation_cancellations", "compras_pledges", :name => "pledge_liquidation_cancellations_pledge_id_fk", :column => "pledge_id"

    add_foreign_key "compras_pledge_liquidations", "compras_pledges", :name => "pledge_liquidations_pledge_id_fk", :column => "pledge_id"

    add_foreign_key "compras_pledge_parcel_movimentations", "compras_pledge_parcels", :name => "pledge_parcel_movimentations_pledge_parcel_id_fk", :column => "pledge_parcel_id"

    add_foreign_key "compras_pledge_parcels", "compras_pledges", :name => "pledge_parcels_pledge_id_fk", :column => "pledge_id"

    add_foreign_key "compras_pledges", "compras_budget_allocations", :name => "pledges_budget_allocation_id_fk", :column => "budget_allocation_id"
    add_foreign_key "compras_pledges", "compras_contracts", :name => "pledges_founded_debt_contract_id_fk", :column => "founded_debt_contract_id"
    add_foreign_key "compras_pledges", "compras_contracts", :name => "pledges_management_contract_id_fk", :column => "contract_id"
    add_foreign_key "compras_pledges", "compras_entities", :name => "pledges_entity_id_fk", :column => "entity_id"
    add_foreign_key "compras_pledges", "compras_expense_kinds", :name => "pledges_expense_kind_id_fk", :column => "expense_kind_id"
    add_foreign_key "compras_pledges", "compras_licitation_modalities", :name => "pledges_licitation_modality_id_fk", :column => "licitation_modality_id"
    add_foreign_key "compras_pledges", "compras_licitation_processes", :name => "pledges_licitation_process_id_fk", :column => "licitation_process_id"
    add_foreign_key "compras_pledges", "compras_management_units", :name => "pledges_management_unit_id_fk", :column => "management_unit_id"
    add_foreign_key "compras_pledges", "compras_pledge_categories", :name => "pledges_pledge_category_id_fk", :column => "pledge_category_id"
    add_foreign_key "compras_pledges", "compras_pledge_historics", :name => "pledges_pledge_historic_id_fk", :column => "pledge_historic_id"
    add_foreign_key "compras_pledges", "compras_providers", :name => "pledges_provider_id_fk", :column => "provider_id"
    add_foreign_key "compras_pledges", "compras_reserve_funds", :name => "pledges_reserve_fund_id_fk", :column => "reserve_fund_id"

    add_foreign_key "compras_precatories", "compras_precatory_types", :name => "precatories_precatory_type_id_fk", :column => "precatory_type_id"
    add_foreign_key "compras_precatories", "compras_providers", :name => "precatories_provider_id_fk", :column => "provider_id"

    add_foreign_key "compras_precatory_parcels", "compras_precatories", :name => "precatory_parcels_precatory_id_fk", :column => "precatory_id"

    add_foreign_key "compras_price_collection_lot_items", "compras_materials", :name => "price_collection_lot_items_material_id_fk", :column => "material_id"
    add_foreign_key "compras_price_collection_lot_items", "compras_price_collection_lots", :name => "price_collection_lot_items_price_collection_lot_id_fk", :column => "price_collection_lot_id"

    add_foreign_key "compras_price_collection_lots", "compras_price_collections", :name => "price_collection_lots_price_collection_id_fk", :column => "price_collection_id"

    add_foreign_key "compras_price_collection_proposal_items", "compras_price_collection_lot_items", :name => "pcpi_price_collection_lot_item_fk", :column => "price_collection_lot_item_id"
    add_foreign_key "compras_price_collection_proposal_items", "compras_price_collection_proposals", :name => "pcpi_price_collection_proposal_fk", :column => "price_collection_proposal_id"

    add_foreign_key "compras_price_collection_proposals", "compras_price_collections", :name => "price_collection_proposals_price_collection_id_fk", :column => "price_collection_id"
    add_foreign_key "compras_price_collection_proposals", "compras_providers", :name => "price_collection_proposals_provider_id_fk", :column => "provider_id"

    add_foreign_key "compras_price_collections", "compras_delivery_locations", :name => "price_collections_delivery_location_id_fk", :column => "delivery_location_id"
    add_foreign_key "compras_price_collections", "compras_employees", :name => "price_collections_employee_id_fk", :column => "employee_id"
    add_foreign_key "compras_price_collections", "compras_payment_methods", :name => "price_collections_payment_method_id_fk", :column => "payment_method_id"

    add_foreign_key "compras_provider_licitation_documents", "compras_document_types", :name => "provider_licitation_documents_document_type_id_fk", :column => "document_type_id"
    add_foreign_key "compras_provider_licitation_documents", "compras_providers", :name => "provider_licitation_documents_provider_id_fk", :column => "provider_id"

    add_foreign_key "compras_provider_partners", "unico_individuals", :name => "provider_partners_individual_id_fk", :column => "individual_id"
    add_foreign_key "compras_provider_partners", "compras_providers", :name => "provider_partners_provider_id_fk", :column => "provider_id"

    add_foreign_key "compras_providers", "compras_agencies", :name => "providers_agency_id_fk", :column => "agency_id"
    add_foreign_key "compras_providers", "compras_cnaes", :name => "providers_cnae_id_fk", :column => "cnae_id"
    add_foreign_key "compras_providers", "compras_economic_registrations", :name => "providers_economic_registration_id_fk", :column => "economic_registration_id"
    add_foreign_key "compras_providers", "unico_people", :name => "providers_person_id_fk", :column => "person_id"
    add_foreign_key "compras_providers", "unico_legal_natures", :name => "providers_legal_nature_id_fk", :column => "legal_nature_id"

    add_foreign_key "compras_purchase_solicitation_budget_allocation_items", "compras_materials", :name => "psbai_material_fk", :column => "material_id"
    add_foreign_key "compras_purchase_solicitation_budget_allocation_items", "compras_purchase_solicitation_budget_allocations", :name => "psbai_purchase_solicitation_budget_allocation_fk", :column => "purchase_solicitation_budget_allocation_id"

    add_foreign_key "compras_purchase_solicitation_budget_allocations", "compras_budget_allocations", :name => "psba_budget_allocation_fk", :column => "budget_allocation_id"
    add_foreign_key "compras_purchase_solicitation_budget_allocations", "compras_expense_natures", :name => "psba_economic_classification_of_expenditure_fk", :column => "expense_nature_id"
    add_foreign_key "compras_purchase_solicitation_budget_allocations", "compras_purchase_solicitations", :name => "psba_purchase_solicitation_fk", :column => "purchase_solicitation_id"

    add_foreign_key "compras_purchase_solicitations", "compras_budget_structures", :name => "purchase_solicitations_organogram_id_fk", :column => "budget_structure_id"
    add_foreign_key "compras_purchase_solicitations", "compras_delivery_locations", :name => "purchase_solicitations_delivery_location_id_fk", :column => "delivery_location_id"
    add_foreign_key "compras_purchase_solicitations", "compras_employees", :name => "purchase_solicitations_liberator_id_fk", :column => "liberator_id"
    add_foreign_key "compras_purchase_solicitations", "compras_employees", :name => "purchase_solicitations_responsible_id_fk", :column => "responsible_id"

    add_foreign_key "compras_registration_cadastral_certificates", "compras_creditors", :name => "registration_cadastral_certificates_creditor_id_fk", :column => "creditor_id"

    add_foreign_key "compras_regularization_or_administrative_sanctions", "compras_creditors", :name => "regularization_or_administrative_sanctions_creditor_id_fk", :column => "creditor_id"
    add_foreign_key "compras_regularization_or_administrative_sanctions", "compras_regularization_or_administrative_sanction_reasons", :name => "regularization_or_administrative_sanction_reasons_fk", :column => "regularization_or_administrative_sanction_reason_id"

    add_foreign_key "compras_regulatory_act_types", "compras_regulatory_act_type_classifications", :name => "toac_cofac_fk", :column => "regulatory_act_type_classification_id"

    add_foreign_key "compras_regulatory_acts", "compras_legal_text_natures", :name => "administractive_acts_legal_texts_nature_id_fk", :column => "legal_text_nature_id"
    add_foreign_key "compras_regulatory_acts", "compras_regulatory_act_types", :name => "administractive_acts_type_of_administractive_act_id_fk", :column => "regulatory_act_type_id"

    add_foreign_key "compras_reserve_fund_annuls", "compras_employees", :name => "compras_reserve_fund_annuls_employee_id_fk", :column => "employee_id"
    add_foreign_key "compras_reserve_fund_annuls", "compras_reserve_funds", :name => "compras_reserve_fund_annuls_reserve_fund_id_fk", :column => "reserve_fund_id"

    add_foreign_key "compras_reserve_funds", "compras_budget_allocations", :name => "reserve_funds_budget_allocation_id_fk", :column => "budget_allocation_id"
    add_foreign_key "compras_reserve_funds", "compras_entities", :name => "reserve_funds_entity_id_fk", :column => "entity_id"
    add_foreign_key "compras_reserve_funds", "compras_licitation_modalities", :name => "reserve_funds_licitation_modality_id_fk", :column => "licitation_modality_id"
    add_foreign_key "compras_reserve_funds", "compras_providers", :name => "reserve_funds_provider_id_fk", :column => "provider_id"
    add_foreign_key "compras_reserve_funds", "compras_reserve_allocation_types", :name => "reserve_funds_reserve_allocation_type_id_fk", :column => "reserve_allocation_type_id"

    add_foreign_key "compras_revenue_accountings", "compras_capabilities", :name => "revenue_accountings_capability_id_fk", :column => "capability_id"
    add_foreign_key "compras_revenue_accountings", "compras_entities", :name => "revenue_accountings_entity_id_fk", :column => "entity_id"
    add_foreign_key "compras_revenue_accountings", "compras_revenue_natures", :name => "revenue_accountings_revenue_nature_id_fk", :column => "revenue_nature_id"

    add_foreign_key "compras_revenue_natures", "compras_entities", :name => "revenue_natures_entity_id_fk", :column => "entity_id"
    add_foreign_key "compras_revenue_natures", "compras_regulatory_acts", :name => "revenue_natures_regulatory_act_id_fk", :column => "regulatory_act_id"
    add_foreign_key "compras_revenue_natures", "compras_revenue_categories", :name => "revenue_natures_revenue_category_id_fk", :column => "revenue_category_id"
    add_foreign_key "compras_revenue_natures", "compras_revenue_rubrics", :name => "revenue_natures_revenue_rubric_id_fk", :column => "revenue_rubric_id"
    add_foreign_key "compras_revenue_natures", "compras_revenue_sources", :name => "revenue_natures_revenue_source_id_fk", :column => "revenue_source_id"
    add_foreign_key "compras_revenue_natures", "compras_revenue_subcategories", :name => "revenue_natures_revenue_subcategory_id_fk", :column => "revenue_subcategory_id"

    add_foreign_key "compras_revenue_rubrics", "compras_revenue_sources", :name => "revenue_rubrics_revenue_source_id_fk", :column => "revenue_source_id"

    add_foreign_key "compras_revenue_sources", "compras_revenue_subcategories", :name => "revenue_sources_revenue_nature_id_fk", :column => "revenue_subcategory_id"

    add_foreign_key "compras_revenue_subcategories", "compras_revenue_categories", :name => "revenue_natures_revenue_category_id_fk", :column => "revenue_category_id"

    add_foreign_key "compras_roles", "compras_profiles", :name => "roles_profile_id_fk", :column => "profile_id"

    add_foreign_key "compras_signature_configuration_items", "compras_signature_configurations", :name => "signature_configuration_items_signature_configuration_id_fk", :column => "signature_configuration_id"
    add_foreign_key "compras_signature_configuration_items", "compras_signatures", :name => "signature_configuration_items_signature_id_fk", :column => "signature_id"

    add_foreign_key "compras_signatures", "unico_people", :name => "signatures_person_id_fk", :column => "person_id"
    add_foreign_key "compras_signatures", "compras_positions", :name => "signatures_position_id_fk", :column => "position_id"

    add_foreign_key "compras_subfunctions", "compras_entities", :name => "subfunctions_entity_id_fk", :column => "entity_id"
    add_foreign_key "compras_subfunctions", "compras_functions", :name => "subfunctions_function_id_fk", :column => "function_id"

    add_foreign_key "compras_supply_authorizations", "compras_direct_purchases", :name => "supply_authorizations_direct_purchase_id_fk", :column => "direct_purchase_id"

    add_foreign_key "compras_users", "compras_profiles", :name => "users_profile_id_fk", :column => "profile_id"
  end
end
