Rails.application.routes.draw do
  devise_for :user_patients, controllers: {
    registrations: 'user_patients/registrations',
    sessions:      'user_patients/sessions'
  }

  root 'main#home'

  # resources :user_patients
end
