Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => "admin#index"

  
  match 'admin/login', via: [:get, :post], as: 'login'
  match 'rp/:hash' => 'users#rp', via: [:get, :patch], as: 'rp'
  get 'admin/logout'
  get 'confirm_email/:hash' => 'users#confirm_email', as: 'confirm_email'

  resources :unsubscribe, only: [:show, :update]

  resources :users do
    collection do
      get  :forgotpw
      post :forgotpw
    end
    member do
      get  :registration_info
      post :resend_email
      get  :editpw
      post :updatepw
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
      get :moorings
      get :unassigned_moorings
      get :labels
      post :download_labels
      get :spreadsheets
      post :download_spreadsheet
      get :initiation_report
    end
    member do
      get :wl
      post :wladd
      get :associate
      post :save_association
      post :unassign
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
    
  resources :wait_list_entries, :except => [:show, :edit, :update] do
    member do
      get :assign
      patch :mooring_update
    end
  end

  resources :mailings do
    get :billing, on: :collection
    post :send_bills, on: :collection
    member do
      post :send_email
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
