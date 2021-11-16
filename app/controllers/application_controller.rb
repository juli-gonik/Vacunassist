class ApplicationController < ActionController::Base

  def actual_user
    @actual_user ||= current_user_patient.present? ? current_user_patient : current_user_vacunator
  end
end
