Rails.application.routes.draw do
  devise_for :user_patients, controllers: {
    registrations: 'user_patients/registrations',
    sessions: 'user_patients/sessions',
    confirmations: 'user_patients/confirmations',
    passwords: 'user_patients/passwords'
  }

  devise_for :user_vacunators, controllers: {
    sessions: 'user_vacunators/sessions',
    confirmations: 'user_vacunators/confirmations',
    passwords: 'user_vacunators/passwords'
  }

  devise_for :user_admins, controllers: {
    registrations: 'user_admins/registrations',
    sessions: 'user_admins/sessions',
    confirmations: 'user_admins/_header_admin' 
  }

  resources :appointments do
    get :vacunator_index, on: :collection
    get :reprogramar_turnos, on: :collection
    get :all_appointments, on: :collection, as: :all_appointments
    get :assign_appointment, on: :member
    get :cancel_appointment, on: :member
    post :assign_covid_under_sixty, on: :member
    get :ask_for_new_appointment, on: :member
    get :historial_de_turnos, on: :collection
    get 'list', on: :collection
    get 'amount_appointments', on: :collection
  end

  resources :certificates do
    get :render_certificate, on: :member
  end

  root 'main#home'

  get '/reset_token', to: 'main#reset_token'
  post '/mandame_aquella', to: 'main#mandame_aquella'

  resources :user_vacunators, except: [:destroy] do
    get :all_user_vacunators, on: :collection
    patch :update_password, on: :member
    get   :edit_password, on: :member
    get   :new_perry, on: :collection
    post  :create_papa, on: :collection
    get :edit_vacunatorio, on: :member
    patch :update_vacunatorio, on: :member
    delete :destroy, on: :member
  end

  resources :user_patients do
    get   :vaccine_certificates, on: :collection
    patch :update_password, on: :member
    get   :edit_password, on: :member
    get   :welcome, on: :member
    get :new_partial, on: :collection
    post :create_partial, on: :collection
    get :complete_profile, on: :member
    patch :handle_complete_profile, on: :member
    get :request_appointment, on: :member
  end

  resources :vacunatorios, only: %i[edit index update]
end
