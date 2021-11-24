Rails.application.routes.draw do
  devise_for :user_patients, controllers: {
    registrations: 'user_patients/registrations',
    sessions:      'user_patients/sessions',
    confirmations: 'user_patients/confirmations' }

  devise_for :user_vacunators, controllers: {
    registrations: 'user_vacunators/registrations',
    sessions:      'user_vacunators/sessions',
    confirmations: 'user_vacunators/confirmations' }

  resources :appointments do
    get :index_confirmed, on: :collection
    get :index_past, on: :collection
    get :index_pending, on: :collection
    get :vacunator_index, on: :collection
    get :reprogramar_turnos, on: :collection
  end

  resources :certificates do
    get :render_certificate, on: :member
  end

  root 'main#home'

  get '/reset_token', to: 'main#reset_token'
  post '/mandame_aquella', to: 'main#mandame_aquella'

  resources :user_patients do
    get   :vaccine_certificates, on: :collection
    patch :update_password, on: :member
    get   :edit_password, on: :member
    get   :welcome, on: :member
  end
end
