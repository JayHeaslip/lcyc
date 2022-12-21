Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => "admin#index"

  get "sign_up", to: "users#new"
  post "sign_up", to: "users#create"
  get "account", to: "users#edit"
  put "account", to: "users#update"
  resources :users
  
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "login", to: "sessions#new"
  
  resources :confirmations, only: [:create, :edit, :new], param: :confirmation_token
  resources :passwords, only: [:create, :edit, :new, :update], param: :password_reset_token
  get "change_password", to: "passwords#change"
  post "change_password", to: "passwords#change"
  
  get 'unsubscribe/:id', to: "unsubscribe#update"
  
  resources :quickbooks do
    collection do
      get :cleanup
      get :connect
      get :update_members
      get :invoices
      post :generate_invoices
    end
  end

  
  resources :roles, :except => [:new] do
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
      get  :new_drysail
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

  resources :people, only: [] do
    collection do
      get :select_committee
      post :committee
    end
  end

  resources :people, only: [], param: :index do
    member do
      delete '(:id)' => "people#destroy", as: ""
    end
  end

  resources :committees, only: [] do
    member do
      post :download_spreadsheet
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

  resources :active_sessions, only: [:destroy] do
    collection do
      delete "destroy_all"
    end
  end

end
