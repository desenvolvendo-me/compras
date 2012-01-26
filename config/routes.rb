Tributario::Application.routes.draw do
  resources :materials_groups do
    collection do
      get :filter
      get :modal
    end
  end


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

  get 'dashboard/calculation'      => 'dashboard/calculation#index'
  get 'dashboard/general'          => 'dashboard/general#index'
  get 'dashboard/economic'         => 'dashboard/economic#index'
  get 'dashboard/lower'            => 'dashboard/lower#index'
  get 'dashboard/management'       => 'dashboard/management#index'

  devise_for :users

  resource :account, :only => %w(edit update)

  resources :accountants do
    collection do
      get :modal
      get :filter
    end
  end

  resources :addresses

  resources :agencies do
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

  resources :districts do
    collection do
      get :modal
      get :filter
    end
  end

  resources :employees do
    collection do
      get :filter
      get :modal
    end
  end

  resources :issqn_classifications do
    collection do
      get :modal
      get :filter
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

  resources :neighborhoods do
    collection do
      get :modal
      get :filter
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
  end

  resources :prefectures do
    collection do
      get :modal
      get :filter
    end
  end

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

  resources :risk_degrees do
    collection do
      get :modal
      get :filter
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

  resources :type_improvements do
    collection do
      get :modal
    end
  end

  resources :users do
    collection do
      get :filter
    end
  end

  resources :working_hours do
    collection do
      get :modal
      get :filter
    end
  end
end
