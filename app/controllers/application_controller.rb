class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def actual_user
    @actual_user ||=
      if current_user_patient.present?
        current_user_patient
      elsif current_user_vacunator.present?
        current_user_vacunator
      elsif current_user_admin.present?
        current_user_admin
      end
  end

  def actual_user_signed_in?
    @actual_user_signed_in ||=
      if current_user_patient.present?
        user_patient_signed_in?
      elsif current_user_vacunator.present?
        user_patient_signed_in?
      elsif current_user_admin.present?
        user_admin_signed_in?
      else
        false
      end
  end

  def after_sign_in_path_for(resource)
    return complete_profile_user_patient_path(actual_user) if actual_user.first_sign_in

    root_path
  end
end
