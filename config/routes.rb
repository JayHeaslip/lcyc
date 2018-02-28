Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => "admin#index"

  
  match 'admin/login', via: [:get, :post], as: 'login'
  match 'rp/:hash' => 'users#rp', via: [:get, :put], as: 'rp'
  get 'admin/logout'
  get 'confirm_email/:hash' => 'users#confirm_email', as: 'confirm_email'
  get 'unsubscribe/:hash' => 'people#unsubscribe', as: 'unsubscribe'

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

  resources :memberships
  
end
