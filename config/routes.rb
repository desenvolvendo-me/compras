Compras::Application.routes.draw do

  root :to => 'bookmarks#show'

  get 'agreements/modal', :as => :modal_agreements

  get 'agreement_kinds/modal', :as => :modal_agreement_kinds

  resources :contract_terminations, :except => [:show, :destroy, :index]

  resources :creditors do
    collection do
      get :filter
      get :modal
    end
    get 'modal_info', :on => :member
  end

  resources :creditor_representatives, :only => :index

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
  devise_for :users, :controllers => {:confirmations => 'confirmations', :sessions => 'sessions'}

  devise_scope :user do
    put '/confirm' => 'confirmations#confirm'
  end

  resource :account, :only => %w(edit update)

  resources :accountants do
    collection do
      get :modal
      get :filter
    end
  end

  resources :purchase_forms do
    collection do
      get :modal
      get :filter
    end
  end

  resources :accounting_cost_centers, only: [:index, :modal] do
    collection do
      get :modal
    end
  end

  resources :accounting_accounts, only: [:index, :modal] do
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
    get 'modal_info', :on => :member
  end

  resources :purchase_process_items do
    collection do
      get :modal
    end
  end

  resources :purchase_process_tradings, only: [:bids, :new] do
    member do
      get :bids
    end
  end

  resources :purchase_process_trading_items, only: [:creditor_list, :next_bid, :undo_last_bid, :update] do
    member do
      get :creditor_list
      get :next_bid
      post :undo_last_bid
    end

    collection do
      get :creditor_winner_items
    end
  end

  resources :purchase_process_trading_item_bids, only: [:update, :show]

  resources :purchase_process_trading_negotiations, only: [:edit, :update, :list] do
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

  resources :purchase_process_trading_item_bid_benefiteds, only: [:new, :create]

  resources :supply_authorizations, :only => [:show, :modal] do
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
    get 'modal_info', :on => :member
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

  resources :budget_allocations, :only => [:index, :show] do
    collection do
      get :filter
      get :modal
    end
    get 'modal_info', :on => :member
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

  get 'budget_structure_levels/modal', :as => :modal_budget_structure_levels

  resources :capabilities, :except => [:new, :edit, :update, :destroy] do
    collection do
      get :filter
      get :modal
    end
    get 'modal_info', :on => :member
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

  resources :contracts do
    resources :delivery_schedules

    collection do
      get :filter
      get :modal
      get :next_sequential
    end
  end

  resources :contract_termination_annuls, :only => [:new, :create, :edit, :update]

  get 'demands/modal', :as => :modal_demands
  resources :demands do
    collection do
      get :filter
      get :modal
    end
  end

  get 'demand_batches/modal', :as => :modal_demand_batches
  resources :demand_batches do
    collection do
      get :filter
      get :modal
    end
  end

  resources :batch_materials do
    collection do
      get :filter
      get :modal
    end
  end

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

  get 'cities/modal', :as => :modal_cities

  get 'cnaes/modal', :as => :modal_cnaes

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

  get 'countries/modal', :as => :modal_coutries

  resources :currencies do
    collection do
      get :modal
      get :filter
    end
  end

  resources :debt_payment_resources, :only => %w(index)

  resources :delivery_locations do
    collection do
      get :filter
      get :modal
    end
  end

  resources :descriptors, :only => :modal do
    collection do
      get :modal
    end
  end

  resources :direct_purchase_annuls, :only => [:new, :create, :edit, :update]

  resources :direct_purchases, :except => [:destroy, :show] do
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

  get 'expense_categories/modal', :as => :modal_expense_categories
  get 'expense_groups/modal', :as => :modal_expense_groups
  get 'expense_modalities/modal', :as => :modal_expense_modalities
  get 'expense_elements/modal', :as => :modal_expense_elements

  resources :expense_natures, :only => [:modal, :index] do
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

  get "functions/modal", :as => :modal_functions

  get "government_programs/modal", :as => :modal_government_programs

  get "individuals/modal", :as => :modal_individuals

  get 'judgment_forms/modal', :as => :modal_judgment_forms
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

  get "legal_natures/modal", :as => :modal_legal_natures

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

  resources :licitation_processes, :except => :destroy do
    collection do
      get :filter
      get :modal
    end
  end

  resources :process_responsibles do
    collection do
      get :filter
      get :modal
    end
  end

  resources :purchase_process_proposals

  resources :purchase_process_creditor_proposals

  resources :creditor_proposal_benefited_tieds, only: [:edit, :update]

  resources :purchase_process_proposal_tiebreaks, only: [:edit, :update]

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

  get 'management_units/modal', :as => :modal_management_units

  resources :materials do
    collection do
      get :filter
      get :modal
    end
  end

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
    end
  end

  get 'occupation_classifications/modal', :as => :modal_occupation_classifications

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
    get 'modal_info', :on => :member
  end

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

  get '/ping' => 'ping#ping'

  get "modal/pledge_categories", :as => "modal_pledge_categories"

  get "modal/pledge_historics", :as => "modal_pledge_historics"

  get "modal/pledge_cancellations", :as => "modal_pledge_cancellations"

  resources :pledge_liquidation_annuls, :except => [:destroy, :update]

  get "pledge_liquidations/modal", :as => "modal_pledge_liquidations"

  resources :pledges, only: [:modal, :index] do
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

  get 'departments/modal', :as => :modal_departments
  resources :departments do
    collection do
      get :filter
      get :modal
    end
  end

  resources :department_people do
    collection do
      get :filter
      get :modal
    end
  end

  resource :prefecture, :except => :destroy

  resources :price_collections, :except => :destroy do
    member do
      post :classification
    end

    collection do
      get :filter
      get :modal
    end
  end

  get 'price_collections/:price_collection_id/price_collection_proposals' => 'price_collection_proposals#index', :as => :price_collection_price_collection_proposals

  resources :price_collection_proposals, :only => [:index, :edit, :update] do
    collection do
      get :modal
    end
  end

  resources :price_collection_annuls, :except => [:index, :show, :destroy]

  resources :price_collection_proposal_annuls, :except => [:index, :show, :destroy]

  resources :profiles do
    collection do
      get :modal
      get :filter
    end
  end

  resources :property_variable_setting_options, :only => :index

  resources :purchase_process_accreditations, :only => [:new, :create, :edit, :update, :show]

  get 'purchase_solicitations/modal', :as => :modal_purchase_solicitations
  resources :purchase_solicitations, :except => :destroy do
    collection do
      get :filter
      get :modal
    end
    get 'modal_info', :on => :member
  end

  resources :purchase_solicitation_annuls, :only => [:new, :create, :edit, :update]

  resources :purchase_solicitation_liberations, :only => [:index, :new, :create, :edit] do
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

  get 'revenue_rubrics/modal', :as => :modal_revenue_rubrics
  get 'revenue_sources/modal', :as => :modal_revenue_sources
  get 'revenue_subcategories/modal', :as => :modal_revenue_subcategories
  get 'revenue_categories/modal', :as => :modal_revenue_categories

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

  get 'stage_processes/modal', :as => :modal_stage_processes
  get 'states/modal', :as => :modal_states

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

  get "subfunctions/modal", :as => :modal_subfunctions

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

  get 'nature_expenses/modal', :as => :modal_nature_expenses
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

  namespace :tce_export do
    resources :monthly_monitorings, :except => :destroy do
      member do
        post :cancel
      end

      collection do
        get :filter
      end
    end
  end

  namespace :report do
    scope :only => [:index, :new, :show] do
      resources :bidding_schedules
      resources :map_of_proposals
      resources :purchase_process_ratifications_by_periods
      resources :purchase_solicitations
      resources :purchased_item_prices
      resources :materials
      resources :contracts
    end

    match 'map_of_bids/:licitation_process_id' => 'map_of_bids#show', as: :map_of_bids

    match 'map_of_prices/:id' => 'map_of_prices#show', as: :map_of_prices

    match 'minute_purchase_processes/:licitation_process_id' => 'minute_purchase_processes#show', as: :minute_purchase_processes
    match 'minute_purchase_process_tradings/:licitation_process_id' => 'minute_purchase_process_tradings#show',
          as: :minute_purchase_process_tradings

    match 'supply_orders/:supply_order_id' => 'supply_orders#show', as: :supply_orders
  end

  namespace :api do
    resources :materials, :only => [:index, :show]
    resources :material_classes
    resources :purchase_processes, only: [:index, :show]
    resources :contracts, only: [:index, :show]
    resources :pledge_requests, only: [:index, :show, :update]
  end
end
