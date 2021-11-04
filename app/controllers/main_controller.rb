class MainController < ApplicationController
  def home
  end

  def reset_token
    @user_patient = UserPatient.new
  end

  def mandame_aquella
    @user_patient = UserPatient.find_by(email: params.dig(:user_patient, :email))
    if @user_patient
      @user_patient.update_column(:access_key, SecureRandom.hex(4))
      UserMailer.with(user_patient: @user_patient).reset_access_key.deliver_now
      redirect_to root_path, notice: 'Token enviado'
    else
      redirect_to root_path, alert: 'Hubo un error'
    end
  end
end
