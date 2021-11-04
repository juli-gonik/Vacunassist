class UserMailer < ApplicationMailer
  default from: 'vacunasis@example.com'

  def reset_access_key
    @user_patient = params[:user_patient]
    mail(to: @user_patient.email, subject: 'Recuperar clave de vacunación')
  end
end
