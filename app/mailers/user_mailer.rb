class UserMailer < ApplicationMailer
  default from: 'vacunasis@example.com'
  helper MainHelper

  def reset_access_key
    @user_patient = params[:user_patient]
    mail(to: @user_patient.email, subject: 'Recuperar clave de vacunación')
  end

  def new_user_patient
    @user_patient = params[:user_patient]
    @url = complete_profile_user_patient_url(@user_patient)
    mail(to: @user_patient.email, subject: 'Registro parcial en VacunAssist')
  end

  def assigned_appointment
    @appointment = params[:appointment]
    mail(to: @appointment.user_patient.email, subject: 'Turno confirmado')
  end

  def canceled_appointment
    @appointment = params[:appointment]
    mail(to: @appointment.user_patient.email, subject: 'Turno cancelado')
  end
end
