Rails.application.routes.draw do
  devise_for :user_patients, controllers: {
    registrations: 'user_patients/registrations',
    sessions:      'user_patients/sessions' }

  resources :appointments do
    get :index_confirmed, on: :collection
    get :index_past, on: :collection
    get :index_pending, on: :collection
  end

  root 'main#home'

  resources :user_patients do
    get :vaccine_certificates, on: :collection
    patch :update_password, on: :member
    get :edit_password, on: :member
  end
end
