class UserPatientsController < ApplicationController
  before_action :set_user_patient, only: [:edit, :update, :show, :edit_password, :update_password]
  def vaccine_certificates
    @patient     = current_user_patient
    @appointment = Appointment.find(params[:appointment_id])
  end

  def show; end

  def edit; end

  def update
    @user_patient = current_user_patient

    if @user_patient.update(user_patient_without_password_params)
      # Sign in the user_patient by passing validation in case their password changed
      # bypass_sign_in(@user_patient)
      redirect_to @user_patient, notice: 'Datos actualizados con exito'
    else
      render :edit
    end
  end

  def edit_password; end

  def update_password
    @user_patient = current_user_patient
    redirect_to @user_patient and return if params.dig(:user_patient, :password).blank? && params.dig(:user_patient, :current_password).blank?

    if @user_patient.update_with_password(user_patient_params)
      # Sign in the user_patient by passing validation in case their password changed
      bypass_sign_in(@user_patient)
      redirect_to @user_patient, notice: 'Contraseña actualizada con exito'
    else
      render :edit_password
    end
  end

  private

  def user_patient_without_password_params
    params.require(:user_patient).permit(:name, :last_name, :vacunatorio_id, :dni, :risk_patient, :birth_date)
  end

  def user_patient_params
    params.require(:user_patient).permit!
  end

  def set_user_patient
    @user_patient = UserPatient.find(params[:id])
  end
end
