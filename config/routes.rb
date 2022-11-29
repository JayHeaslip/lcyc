Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => "admin#index"

  get "sign_up", to: "users#new"
  post "sign_up", to: "users#create"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "login", to: "sessions#new"
  
  resources :confirmations, only: [:create, :edit, :new], param: :confirmation_token
  resources :passwords, only: [:create, :edit, :new, :update], param: :password_reset_token
  get "change_password", to: "passwords#change"
  post "change_password", to: "passwords#change"
  
  resources :unsubscribe, only: [:show, :update]
  
  resources :quickbooks do
    collection do
      get :cleanup
      get :connect
      get :update_members
      get :invoices
      post :generate_invoices
    end
  end

  resources :users do
    member do
      get  :registration_info
      post :resend_email
    end
  end
  
  resources :roles, :except => [:new] do
    resources :users do
      member do
        delete :rmrole
      end
    end
  end

  resources :memberships do
    collection do
      get  :moorings
      get  :drysail
      get  :unassigned_moorings
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
    get :new_billing, on: :collection
    post :create_billing, on: :collection
    member do
      get :billing
      post :send_email
      get :edit_billing
      patch :update_billing
      post :send_bills
    end
  end
  
  resources :binnacles do
    member do
      get :email
      post :send_email
    end
  end

  resources :preview, :only => [:show]
  resources :binnacle_preview, :only => [:show]

end
