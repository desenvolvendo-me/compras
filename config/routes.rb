# frozen_string_literal: true

Compras::Application.routes.draw do
  root to: "bookmarks#show"

  get "agreements/modal", as: :modal_agreements

  get "agreement_kinds/modal", as: :modal_agreement_kinds

  resources :contract_terminations, except: %i[show destroy index]

  resources :creditors do
    collection do
      get :filter
      get :modal
    end
    get "modal_info", on: :member
  end

  resources :creditor_representatives, only: :index

  resources :holidays do
    collection do
      get :filter
      get :modal
    end
  end

  resources :indexers do
    collection do
      get :filter
      get :modal
    end
  end

  resources :installment_terms do
    collection do
      get :modal
      get :filter
    end
  end

  # Keep routes sorted alphabetically
  devise_for :users, controllers: { confirmations: "confirmations", sessions: "sessions" }

  devise_scope :user do
    put "/confirm" => "confirmations#confirm"
  end

  resource :account, only: %w[edit update]

  resources :accountants do
    collection do
      get :modal
      get :filter
    end
  end

  resources :management_objects, controller: "auction/management_objects" do
    collection do
      get :filter
      get :modal
    end
  end

  resources :purchase_forms do
    collection do
      get :modal
      get :filter
    end
  end

  resources :accounting_cost_centers, only: %i[index modal] do
    collection do
      get :modal
    end
  end

  resources :accounting_accounts, only: %i[index modal] do
    collection do
      get :modal
    end
  end

  resources :addresses

  resources :regulatory_acts do
    collection do
      get :filter
      get :modal
    end
    get "modal_info", on: :member
  end

  resources :purchase_process_items do
    collection do
      get :modal
    end
  end

  resources :purchase_process_tradings, only: %i[bid_form bids new] do
    collection do
      get :bid_form
    end

    member do
      get :bids
    end
  end

  resources :purchase_process_trading_items, only: %i[creditor_list next_bid undo_last_bid update] do
    member do
      get :creditor_list
      get :next_bid
      post :undo_last_bid
    end

    collection do
      get :creditor_winner_items
    end
  end

  resources :purchase_process_trading_item_bids, only: %i[create update show]

  resources :purchase_process_trading_negotiations, only: %i[edit update list] do
    member do
      get :list
    end
  end

  resources :agencies do
    collection do
      get :modal
      get :filter
    end
  end

  resources :purchase_process_trading_item_bid_benefiteds, only: %i[new create]

  resources :supply_authorizations, only: %i[show modal] do
    collection do
      get :modal
    end
  end

  resources :supply_orders do
    collection do
      get :modal
      get :filter
    end
  end

  namespace :generator do
    resources :generator_supply_orders, except: :destroy do
      member do
        post :cancel
      end

      if Rails.env.development?
        member do
          get :without_sidekiq
        end
      end

      collection do
        get :filter
      end
    end
  end

  resources :supply_requests do
    collection do
      get :modal
      get :filter
    end
  end
  match "api/supply_requests/show" => "supply_requests#api_show", as: :supply_requests_api_show

  resources :supply_request_managements, only: %i[index new] do
    collection do
      get :filter
      get :modal
    end
  end

  resources :supply_request_attendances, only: %i[index new create edit] do
    collection do
      get :filter
      get :modal
    end
  end

  resources :banks do
    collection do
      get :modal
      get :filter
    end
  end

  resources :bank_accounts do
    collection do
      get :filter
      get :modal
    end
    get "modal_info", on: :member
  end

  resources :branch_activities do
    collection do
      get :modal
      get :filter
    end
  end

  resources :branch_classifications do
    collection do
      get :modal
      get :filter
    end
  end

  resource :bookmark do
    member do
      get :empty
    end
  end

  resources :budget_allocations, only: %i[index show] do
    collection do
      get :filter
      get :modal
    end
    get "modal_info", on: :member
  end

  resources :budget_revenues do
    collection do
      get :filter
      get :modal
    end
  end

  resources :budget_structure_configurations do
    collection do
      get :filter
      get :modal
    end
  end

  resources :budget_structures do
    collection do
      get :filter
      get :modal
    end
  end

  get "budget_structure_levels/modal", as: :modal_budget_structure_levels

  resources :capabilities, except: %i[new edit update destroy] do
    collection do
      get :filter
      get :modal
    end
    get "modal_info", on: :member
  end

  resources :capability_allocation_details do
    collection do
      get :filter
      get :modal
    end
  end

  resources :capability_destinations do
    collection do
      get :filter
      get :modal
    end
  end

  resources :capability_sources do
    collection do
      get :filter
      get :modal
    end
  end

  resources :company_sizes do
    collection do
      get :modal
      get :filter
    end
  end

  resources :contract_additives do
    collection do
      get :filter
      get :modal
    end
  end

  resources :additive_solicitations do
    collection do
      get :filter
      get :modal
    end
  end

  post "additive_solicitation/margin" => "additive_solicitations#margin", as: :additive_solicitation_material_margin

  resources :contracts do
    resources :delivery_schedules
    get :conference
    collection do
      get :filter
      get :modal
      get :next_sequential
    end
  end

  resources :contract_validations, only: %i[index new create edit] do
    collection do
      get :filter
      get :modal
    end
  end

  post "contract/plegde_request" => "contracts#plegde_request", as: :contracts_plegde_request

  resources :contract_termination_annuls, only: %i[new create edit update]

  resources :balance_adjustments

  get "demands/modal", as: :modal_demands
  resources :demands do
    collection do
      get :filter
      get :modal
    end
  end

  match "api/demands/show" => "demands#api_show", as: :demands_api_show

  resources :contract_types do
    collection do
      get :filter
      get :modal
    end
  end

  resources :classification_of_types_of_administractive_acts do
    collection do
      get :filter
      get :modal
    end
  end

  resources :cities, only: %w[index show] do
    collection do
      get :modal
      get :by_name_and_state
    end
  end

  get "cnaes/modal", as: :modal_cnaes
  resources :cnaes

  resources :communication_sources do
    collection do
      get :filter
      get :modal
    end
  end

  resources :condominia do
    collection do
      get :modal
      get :filter
    end
  end

  get "countries/modal", as: :modal_coutries

  resources :currencies do
    collection do
      get :modal
      get :filter
    end
  end

  resources :debt_payment_resources, only: %w[index]

  resources :delivery_locations do
    collection do
      get :filter
      get :modal
    end
  end

  resources :descriptors, only: :modal do
    collection do
      get :modal
    end
  end

  resources :direct_purchase_annuls, only: %i[new create edit update]

  resources :direct_purchases, except: %i[destroy show] do
    collection do
      get :filter
      get :modal
    end
  end

  resources :districts do
    collection do
      get :modal
      get :filter
    end
  end

  resources :dissemination_sources do
    collection do
      get :filter
      get :modal
    end
  end

  resources :document_types do
    collection do
      get :filter
      get :modal
    end
  end

  get "expense_categories/modal", as: :modal_expense_categories
  get "expense_groups/modal", as: :modal_expense_groups
  get "expense_modalities/modal", as: :modal_expense_modalities
  get "expense_elements/modal", as: :modal_expense_elements

  resources :expense_natures, only: %i[modal index] do
    collection do
      get :modal
    end
  end

  resources :employees do
    collection do
      get :filter
      get :modal
    end
  end

  get "functions/modal", as: :modal_functions

  get "government_programs/modal", as: :modal_government_programs

  get "individuals/modal", as: :modal_individuals

  get "judgment_forms/modal", as: :modal_judgment_forms
  resources :judgment_forms do
    collection do
      get :filter
      get :modal
    end
  end

  resources :judgment_commission_advices do
    collection do
      get :filter
      get :modal
    end
  end

  resources :land_subdivisions do
    collection do
      get :modal
      get :filter
    end
  end

  resources :legal_analysis_appraisals do
    collection do
      get :filter
      get :modal
    end
  end

  get "legal_natures/modal", as: :modal_legal_natures

  resources :legal_references do
    collection do
      get :filter
      get :modal
    end
  end

  resources :licitation_commissions do
    collection do
      get :filter
      get :modal
    end
  end

  resources :licitation_notices do
    collection do
      get :filter
      get :modal
    end
  end

  resources :licitation_process_appeals do
    collection do
      get :filter
      get :modal
    end
  end

  resources :licitation_process_impugnments do
    collection do
      get :filter
      get :modal
    end
  end

  resources :licitation_process_ratifications do
    collection do
      get :filter
      get :modal
    end
  end

  resources :licitation_process_ratification_items, only: :index

  resources :licitation_processes, except: :destroy do
    collection do
      get :filter
      get :modal
      get :add_bidders
      get :add_trading_negotiation
      get :add_ratifications
    end
  end

  post "licitation_process/material_total_balance" => "licitation_processes#material_total_balance", as: :licitation_process_material_total_balance

  resources :secretaries do
    collection do
      get :filter
      get :modal
    end
  end

  resources :secretary_settings do
    member do
      get :router
    end
    collection do
      get :signature_generate
    end
  end

  resources :process_responsibles do
    collection do
      get :filter
      get :modal
    end
  end

  resources :purchase_process_proposals

  resources :purchase_process_creditor_proposals, except: :destroy
  delete "/purchase_process_creditor_proposals/", to: "purchase_process_creditor_proposals#destroy", as: :purchase_process_creditor_proposal

  resources :creditor_proposal_benefited_tieds, only: %i[edit update]

  resources :purchase_process_proposal_tiebreaks, only: %i[edit update]

  resources :purchase_process_creditor_disqualifications, except: :destroy do
    collection do
      get :creditors
      get :batch_edit
      put :batch_update
    end
  end

  resources :bidders do
    collection do
      get :filter
      get :modal
    end
  end

  resources :licitation_process_publications do
    collection do
      get :filter
      get :modal
    end
  end

  get "management_units/modal", as: :modal_management_units

  resources :materials do
    collection do
      get :filter
      get :modal
    end
  end
  match "api/materials/show" => "materials#api_show", as: :material_api_show

  resources :material_classes do
    collection do
      get :filter
      get :modal
    end
  end

  resources :neighborhoods do
    collection do
      get :modal
      get :filter
      get :by_name_and_city
    end
  end

  get "occupation_classifications/modal", as: :modal_occupation_classifications

  resources :payment_methods do
    collection do
      get :filter
      get :modal
    end
  end

  resources :parcels do
    collection do
      get :filter
    end
  end

  resources :people do
    collection do
      get :modal
      get :filter
    end
    get "modal_info", on: :member
  end
  get "/legal_peoples", to: "people#index", as: "legal_peoples", by_legal_people: true
  get "/legal_peoples/new", to: "people#new", as: "new_legal_people", by_legal_people: true

  get "/physical_peoples", to: "people#index", as: "physical_peoples", by_physical_people: true
  get "/physical_peoples/new", to: "people#new", as: "new_physical_people", by_physical_people: true

  get "representative_people", to: "people#index", as: "representative_people"
  get "responsibles", to: "people#index", as: "responsibles"

  resources :pledge_requests do
    collection do
      get :modal
      get :filter
    end
  end

  resources :occurrence_contractual_historics do
    collection do
      get :filter
      get :modal
    end
  end

  get "/ping" => "ping#ping"

  get "modal/pledge_categories", as: "modal_pledge_categories"

  get "modal/pledge_historics", as: "modal_pledge_historics"

  get "modal/pledge_cancellations", as: "modal_pledge_cancellations"

  resources :pledge_liquidation_annuls, except: %i[destroy update]

  get "pledge_liquidations/modal", as: "modal_pledge_liquidations"

  resources :pledges, only: %i[modal index] do
    collection do
      get :modal
    end
  end

  resources :pledge_items, only: :index

  resources :positions do
    collection do
      get :filter
      get :modal
    end
  end

  get "departments/modal", as: :modal_departments
  resources :departments do
    collection do
      get :filter
      get :modal
    end
  end

  resource :prefecture, except: :destroy

  resources :price_collections, except: :destroy do
    member do
      post :classification
      get :edit_proposal
    end

    collection do
      get :filter
      get :modal
    end
  end

  get "price_collections/:price_collection_id/price_collection_proposals" => "price_collection_proposals#index", :as => :price_collection_price_collection_proposals

  resources :price_collection_proposals, only: %i[index edit update] do
    collection do
      get :modal
    end
  end

  resources :price_collection_annuls, except: %i[index show destroy]

  resources :price_collection_proposal_annuls, except: %i[index show destroy]

  resources :profiles do
    collection do
      get :modal
      get :filter
    end
  end

  resources :property_variable_setting_options, only: :index

  resources :purchase_process_accreditations, only: %i[new create edit update show]

  get "purchase_solicitations/modal", as: :modal_purchase_solicitations
  resources :purchase_solicitations, except: :destroy do
    collection do
      get :filter
      get :modal
    end
    get "modal_info", on: :member
  end

  match "api/purchase_solicitations/show" => "purchase_solicitations#api_show", as: :purchase_solicitations_api_show

  get "purchase_solicitation/department" => "purchase_solicitations#department", as: :purchase_solicitation_department
  get "purchase_solicitation/balance" => "purchase_solicitations#balance", as: :purchase_solicitation_balance

  resources :purchase_solicitation_annuls, only: %i[new create edit update]

  resources :purchase_solicitation_liberations, only: %i[index new create edit] do
    collection do
      get :filter
      get :modal
    end
  end

  resources :realignment_prices do
    collection do
      get :filter
      get :modal
    end
  end

  resources :realignment_price_items, only: :index

  resources :reference_units do
    collection do
      get :modal
      get :filter
    end
  end

  resources :registration_cadastral_certificates do
    collection do
      get :modal
      get :filter
    end
  end

  resources :registration_terms do
    collection do
      get :modal
      get :filter
    end
  end

  resources :regularization_or_administrative_sanction_reasons do
    collection do
      get :filter
      get :modal
    end
  end

  resources :reserve_fund_requests do
    collection do
      get :filter
      get :modal
    end

    member do
      get :reserve_funds_grid
    end
  end

  resources :reserve_funds do
    collection do
      get :modal
    end
  end

  get "revenue_rubrics/modal", as: :modal_revenue_rubrics
  get "revenue_sources/modal", as: :modal_revenue_sources
  get "revenue_subcategories/modal", as: :modal_revenue_subcategories
  get "revenue_categories/modal", as: :modal_revenue_categories

  resources :side_streets do
    collection do
      get :modal
    end
  end

  resources :signature_configurations do
    collection do
      get :filter
      get :modal
    end
  end

  resources :signatures do
    collection do
      get :filter
      get :modal
    end
  end

  resources :special_entries do
    collection do
      get :filter
      get :modal
    end
  end

  get "stage_processes/modal", as: :modal_stage_processes
  get "states/modal", as: :modal_states

  resources :street_types do
    collection do
      get :modal
      get :filter
    end
  end

  resources :streets do
    collection do
      get :modal
      get :filter
    end
  end

  get "subfunctions/modal", as: :modal_subfunctions

  resources :tce_specification_capabilities do
    collection do
      get :filter
      get :modal
    end
  end

  resources :type_improvements do
    collection do
      get :modal
    end
  end

  resources :regulatory_act_types do
    collection do
      get :filter
      get :modal
    end
  end

  resources :holidays do
    collection do
      get :filter
      get :modal
    end
  end

  get "nature_expenses/modal", as: :modal_nature_expenses
  resources :nature_expenses do
    collection do
      get :filter
      get :modal
    end
  end

  resources :project_activities do
    collection do
      get :filter
      get :modal
    end
  end

  resources :project_activities do
    collection do
      get :filter
      get :modal
    end
  end

  resources :purchasing_units do
    collection do
      get :filter
      get :modal
    end
  end

  resources :expenses do
    collection do
      get :filter
      get :modal
    end
  end

  resources :programs do
    collection do
      get :filter
      get :modal
    end
  end

  resources :expense_sub_functions do
    collection do
      get :filter
      get :modal
    end
  end

  resources :expense_functions do
    collection do
      get :filter
      get :modal
    end
  end

  resources :organs do
    collection do
      get :filter
      get :modal
    end
  end

  resources :resource_sources do
    collection do
      get :filter
      get :modal
    end
  end

  resources :split_expenses do
    collection do
      get :filter
      get :modal
    end
  end

  resources :unblock_budgets

  resources :users do
    collection do
      get :filter
      get :modal
    end
  end

  get "/zendesk" => "zendesk#index"

  namespace :tce_export do
    resources :monthly_monitorings, except: :destroy do
      member do
        post :cancel
      end

      collection do
        get :filter
      end
    end
  end
  namespace :auction do
    get "/external" => "auctions#external_index", as: :auctions_external_index

    resources :auction_creditor_proposals do
      collection do
        get :auctioneer_view
      end
    end

    get "legal_peoples", to: "people#index", as: "auction_legal_peoples", by_legal_people: true
    get "legal_peoples/new", to: "people#new", as: "new_auction_legal_people", by_legal_people: true
    post "legal_peoples/edit", to: "people#edit", as: "edit_auction_legal_people", by_legal_people: true
    get "legal_peoples/check", to: "people#check", as: "check_auction_legal_people"
    post "legal_peoples", to: "people#create", as: "create_auction_legal_people"

    resources :people do
      collection do
        get :filter
        get :modal
      end
    end

    resources :appeals do
      collection do
        get :filter
        get :modal
        get :mark_viewed
      end
    end

    resources :creditors do
      collection do
        get :filter
        get :modal
      end
      get "modal_info", on: :member
    end

    resources :employees do
      collection do
        get :filter
        get :modal
      end
    end
    resources :positions do
      collection do
        get :filter
        get :modal
      end
    end

    resources :auctions do
      member do
        get :dashboard
      end

      collection do
        get :filter
        get :modal
      end

      resources :suspensions
    end

    scope 'auction/:auction_id' do
      resources :dispute_items do
        collection do
          get :closed_items
        end
      end
    end

    resources :auction_items, only: [:index]
    get "/auction_items/group_lot" => "auction_items#group_lot", as: :group_lot_items

    resources :management_objects do
      collection do
        get :filter
        get :modal
      end
    end

    get "/providers/register" => "providers#register_external", as: :providers_register_external
    post "/providers/check_register" => "providers#check_register_external", as: :providers_check_register_external

    resources :providers do
      collection do
        get :filter
        get :modal
      end
    end
  end

  namespace :report do
    scope only: %i[index new show] do
      resources :bidding_schedules
      resources :map_of_proposals
      resources :purchase_process_ratifications_by_periods
      resources :purchase_solicitations
      resources :purchased_item_prices
      resources :materials
      resources :supplier_balance_per_service_orders
      resources :contracts
      resources :licitation_processes
      resources :department_requests
      resources :pledge_requests
      resources :balance_per_creditors
      resources :balance_per_process_and_contracts
      resources :total_products_purchases
      resources :total_purchase_per_element_and_natures
      resources :extract_consumption_per_processes
      resources :contract_per_resource_sources
      resources :supply_request_per_secretaries
      resources :expenses
      resources :purchase_solicitation_items
    end

    match "map_of_bids/:licitation_process_id" => "map_of_bids#show", as: :map_of_bids

    match "map_of_prices/:id" => "map_of_prices#show", as: :map_of_prices

    match "minute_purchase_processes/:licitation_process_id" => "minute_purchase_processes#show", as: :minute_purchase_processes
    match "minute_purchase_process_tradings/:licitation_process_id" => "minute_purchase_process_tradings#show",
          as: :minute_purchase_process_tradings

    match "supply_orders/:supply_order_id" => "supply_orders#show", as: :supply_orders
    match "supply_requests/:supply_request_id" => "supply_requests#show", as: :supply_requests
    match "creditor_materials" => "creditor_materials#show", as: :creditor_materials
  end

  namespace :api do
    resources :materials, only: %i[index show]
    resources :material_classes
    resources :purchase_processes, only: %i[index show]
    resources :contracts, only: %i[index show]
    resources :pledge_requests, only: %i[index show update]
    namespace :auction do
      resources :purchase_process_proposals
      resources :licitation_processes
    end
  end

  namespace :dashboard do
    resources :secretaries, only: :index do
      collection do
        get "/contracts", to: "secretaries#contracts", as: :contracts
        get "/linked_contracts", to: "secretaries#linked_contracts", as: :linked_contracts
        get "/approval_requests", to: "secretaries#approval_requests", as: :approval_requests
      end
    end
  end
end
