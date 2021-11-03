Rails.application.routes.draw do
  devise_for :user_patients, controllers: {
    registrations: 'user_patients/registrations',
    sessions:      'user_patients/sessions'
  }

  root 'main#home'

  resources :user_patients
  # resources :user_patients

  resources :users do
    member do
      get :confirm_email
    end
  end
end
