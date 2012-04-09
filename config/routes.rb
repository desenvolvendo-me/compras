Tributario::Application.routes.draw do

  resources :fiscal_years do
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

  resources :installment_terms do
    collection do
      get :modal
      get :filter
    end
  end

  namespace :iss_intel do
    post 'companies/sync'
    post 'individuals/sync'
  end

  # Keep routes sorted alphabetically
  root :to => 'bookmarks#show'

  devise_for :users

  resource :account, :only => %w(edit update)

  resources :accountants do
    collection do
      get :modal
      get :filter
    end
  end

  resources :addresses

  resources :regulatory_acts do
    collection do
      get :filter
      get :modal
    end
  end

  resources :administration_types do
    collection do
      get :filter
      get :modal
    end
  end

  resources :administrative_processes, :except => [:update, :destroy] do
    collection do
      get :filter
      get :modal
    end
  end

  resources :agencies do
    collection do
      get :modal
      get :filter
    end
  end

  resources :supply_authorizations, :except => [:update, :destroy] do
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

  resources :budget_allocations do
    collection do
      get :filter
      get :modal
    end
  end

  resources :budget_allocation_types do
    collection do
      get :filter
      get :modal
    end
  end

  resources :budget_unit_configurations do
    collection do
      get :filter
      get :modal
    end
  end

  resources :budget_units do
    collection do
      get :filter
      get :modal
    end
  end

  resources :capabilities do
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

  resources :regulatory_act_type_classifications do
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

  resources :cities do
    collection do
      get :modal
      get :filter
    end
  end

  resources :cnaes do
    collection do
      get :modal
      get :filter
    end
  end

  resources :communication_sources do
    collection do
      get :filter
      get :modal
    end
  end

  resources :condominium_types do
    collection do
      get :modal
      get :filter
    end
  end

  resources :condominiums do
    collection do
      get :modal
      get :filter
    end
  end

  resources :creditors do
    collection do
      get :filter
      get :modal
    end
  end

  resources :countries do
    collection do
      get :modal
      get :filter
    end
  end

  resources :currencies do
    collection do
      get :modal
      get :filter
    end
  end

  resources :debt_payment_resources, :only => %w(index)

  resources :delayed_calculations do
    collection do
      get :filter
    end
  end

  resources :delivery_locations do
    collection do
      get :filter
      get :modal
    end
  end

  resources :direct_purchases, :except => :destroy do
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

  resources :economic_registrations do
    collection do
      get :modal
      get :filter
    end
  end

  resources :expense_elements do
    collection do
      get :filter
      get :modal
    end
  end

  resources :extra_credits do
    collection do
      get :filter
      get :modal
    end
  end

  resources :extra_credit_natures do
    collection do
      get :filter
      get :modal
    end
  end

  resources :employees do
    collection do
      get :filter
      get :modal
    end
  end

  resources :entities do
    collection do
      get :filter
      get :modal
    end
  end

  resources :expense_kinds do
    collection do
      get :filter
      get :modal
    end
  end

  resources :founded_debt_contracts do
    collection do
      get :filter
      get :modal
    end
  end

  resources :functions do
    collection do
      get :filter
      get :modal
    end
  end

  resources :government_actions do
    collection do
      get :filter
      get :modal
    end
  end

  resources :government_programs do
    collection do
      get :filter
      get :modal
    end
  end

  get "individuals/modal", :as => :modal_individuals

  resources :judgment_forms do
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

  resources :legal_natures, :only => :index do
    collection do
      get :modal
    end
  end

  resources :legal_references do
    collection do
      get :filter
      get :modal
    end
  end

  resources :legal_text_natures do
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

  resources :licitation_modalities do
    collection do
      get :filter
      get :modal
    end
  end

  resources :licitation_objects do
    collection do
      get :filter
      get :modal
    end
  end

  resources :licitation_processes do
    collection do
      get :filter
      get :modal
    end
  end

  resources :management_contracts do
    collection do
      get :filter
      get :modal
    end
  end

  resources :management_units do
    collection do
      get :filter
      get :modal
    end
  end

  resources :materials do
    collection do
      get :filter
      get :modal
    end
  end

  resources :materials_classes do
    collection do
      get :filter
      get :modal
    end
  end

  resources :materials_groups do
    collection do
      get :filter
      get :modal
    end
  end

  resources :modality_limits do
    collection do
      get :filter
      get :modal
    end
  end

  get "moviment_types/modal", :as => :modal_moviment_types

  resources :neighborhoods do
    collection do
      get :modal
      get :filter
    end
  end

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

  resources :periods do
    collection do
      get :filter
      get :modal
    end
  end

  resources :people do
    collection do
      get :modal
      get :filter
    end
  end

  resources :pledge_categories do
    collection do
      get :filter
      get :modal
    end
  end

  resources :pledge_historics do
    collection do
      get :filter
      get :modal
    end
  end

  resources :pledge_cancellations, :except => [:destroy, :update] do
    collection do
      get :filter
      get :modal
    end
  end

  get "pledge_expirations/modal", :as => :modal_pledge_expirations

  resources :pledges, :except => [:destroy, :update] do
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

  resource :prefecture, :except => :destroy

  resources :procedures, :only => %w(index show) do
    collection do
      get :modal
    end
  end

  resources :profiles do
    collection do
      get :modal
      get :filter
    end
  end

  resources :property_variable_setting_options, :only => :index

  resources :providers do
    collection do
      get :filter
      get :modal
    end
  end

  resources :purchase_solicitations do
    collection do
      get :filter
      get :modal
    end
  end

  resources :reference_units do
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

  resources :reserve_allocation_types do
    collection do
      get :filter
      get :modal
    end
  end

  resources :reserve_funds do
    collection do
      get :filter
      get :modal
    end
  end

  get 'revenue_rubrics/modal', :as => :modal_revenue_rubrics
  get 'revenue_sources/modal', :as => :modal_revenue_sources
  get 'revenue_subcategories/modal', :as => :modal_revenue_subcategories
  get 'revenue_categories/modal', :as => :modal_revenue_categories

  resources :revenue_natures do
    collection do
      get :filter
      get :modal
    end
  end

  resources :risk_degrees do
    collection do
      get :modal
      get :filter
    end
  end

  resources :service_or_contract_types do
    collection do
      get :filter
      get :modal
    end
  end

  resources :side_streets do
    collection do
      get :modal
    end
  end

  resources :states do
    collection do
      get :modal
      get :filter
    end
  end

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

  resources :settings, :only => %w(index edit update) do
    collection do
      get :filter
    end
  end

  resources :subfunctions do
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

  resources :users do
    collection do
      get :filter
    end
  end
end
