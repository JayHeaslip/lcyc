Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => "admin#index"

  get "sign_up", to: "users#new"
  post "sign_up", to: "users#create"
  get "account", to: "users#edit"
  put "account", to: "users#update"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  get "change_password", to: "passwords#change"
  post "change_password", to: "passwords#change"
  get 'unsubscribe/:id', to: "unsubscribe#update"

  resources :users
  
  resources :confirmations, only: [:create, :edit, :new], param: :confirmation_token
  resources :passwords, only: [:create, :edit, :new, :update], param: :password_reset_token
  
  resources :quickbooks do
    collection do
      get :cleanup
      get :connect
      get :update_members
      get :invoices
      post :generate_invoices
    end
  end

  
  resources :roles, :except => [:new, :destroy] do
    resources :users do
      member do
        delete :rmrole
      end
    end
  end

  resources :moorings, only: [:index] do
    collection do
      get :unassigned
    end
  end 

  resources :drysails, only: [:index, :update] do
    member do
      get :assign
    end
  end
  
  resources :memberships do
    collection do
      get :list
      get  :labels
      post :download_labels
      get  :spreadsheets
      post :download_spreadsheet
      get  :initiation_report
      post :assign_drysail
      post :add_person
    end
    member do
      get :wl
      post :wladd
      get :associate
      post :save_association
      post :unassign
      post :unassign_drysail
    end
    resources :people
    resources :boats
  end

  resources :people, only: [:destroy]

  resources :committees, only: [] do
    collection do
      get :select
      get :list
      get :download_all
    end
    member do
      get :download
    end
  end
  
  resources :boats do
    member do
      get :associate
      post :save_association
    end
    resources :memberships do
      member do
        delete :rmboat
      end
    end
  end
    
  resources :wait_list_entries, :except => [:show] do
    member do
      get :assign
      patch :mooring_update
    end
  end

  resources :mailings do
    member do
      post :send_email
    end
  end
  get "loginfo_mailing", to: "mailings#loginfo"
  post "loginfo_mailing", to: "mailings#loginfo"

  resources :active_sessions, only: [:index, :destroy] do
    collection do
      delete "destroy_all"
    end
  end

  get "summary_report", to: "reports#summary"
  
end
