class ApplicationController < ActionController::Base
  before_action :complete_profile
  def actual_user
    @actual_user ||= current_user_patient.present? ? current_user_patient : current_user_vacunator
  end

  def actual_user_signed_in?
    @actual_user_signed_in ||= current_user_patient.present? ? user_patient_signed_in? : user_vacunator_signed_in?
  end

  private

  def complete_profile
    return if params[:action] == 'destroy'
    if actual_user_signed_in? && actual_user.instance_of?(UserPatient)
      redirect_to complete_profile_user_patient_path(actual_user) if actual_user.first_sign_in
    end 
  end 
end
