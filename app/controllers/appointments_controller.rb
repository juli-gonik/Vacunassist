class AppointmentsController < ApplicationController
  def index
    @appointments = current_user_patient.appointments
  end

  def index_pending
    @appointments = current_user_patient.appointments.pending
  end

  def index_confirmed
    @appointments = current_user_patient.appointments.confirmed
  end

  def index_past
    @appointments = current_user_patient.appointments.past
  end
end
