class UserPatientsController < ApplicationController
  def vaccine_certificates
    @patient     = current_user_patient
    @appointment = Appointment.find(params[:appointment_id])
  end
end
