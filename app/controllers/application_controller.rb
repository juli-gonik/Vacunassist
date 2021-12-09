class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def actual_user
    @actual_user ||= current_user_patient.present? ? current_user_patient : current_user_vacunator
  end

  def actual_user_signed_in?
    @actual_user_signed_in ||= current_user_patient.present? ? user_patient_signed_in? : user_vacunator_signed_in?
  end

  def after_sign_in_path_for(resource)
    return complete_profile_user_patient_path(actual_user) if actual_user.first_sign_in

    root_path
  end
end
