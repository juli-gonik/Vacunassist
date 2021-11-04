# frozen_string_literal: true
class UserPatients::RegistrationsController < Devise::RegistrationsController
  include MainHelper
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  def new
    @user_patient = UserPatient.new
    @gripe = @user_patient.appointments.build(vaccine: 'gripe', tipo: 0, status: 2)
    @covid = @user_patient.appointments.build(vaccine: 'covid', tipo: 0, status: 2)
  end

  def create
    @user_patient = UserPatient.new(user_patient_params)

    if @user_patient.save
      @user_patient.appointments.each { |appointment| check_status(appointment) }
      new_covid_appointment(@user_patient)
      new_gripe_appointment(@user_patient)
      redirect_to root_path, notice: 'Registro exitoso, le llegará un correo para validar el email'
    else
      @gripe = @user_patient.appointments.select { |appointment| appointment.vaccine == 'gripe' }.first
      @covid = @user_patient.appointments.select { |appointment| appointment.vaccine == 'covid' }.first
      render :new
    end
  end

  private

  def new_covid_appointment(user_patient)
    @covid = @user_patient.appointments.select { |appointment| appointment.vaccine == 'covid' }.last
    return unless user_patient.age >= 18 && @covid.dose < 2

    dose = @covid.dose.zero? ? 1 : 2
    user_patient.appointments.create(vaccine: 'covid', dose: dose, tipo: 1, last_dose_date: @covid.last_dose_date)
  end

  def new_gripe_appointment(user_patient)
    @gripe = @user_patient.appointments.select { |appointment| appointment.vaccine == 'gripe' }.last
    return unless @gripe.last_dose_date.present? && @gripe.last_dose_date < 1.year.ago

    user_patient.appointments.create(vaccine: 'gripe', tipo: 1, last_dose_date: @gripe.last_dose_date)
  end

  def check_status(appointment)
    return unless appointment.tipo == 'sistema'

    case appointment.vaccine
    when 'covid'
      appointment.not_valid! if appointment.dose.zero?
    when 'gripe'
      appointment.not_valid! if appointment.last_dose_date.nil?
    end
  end

  def user_patient_params
    params.require(:user_patient).permit!
  end
  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    root_path
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
