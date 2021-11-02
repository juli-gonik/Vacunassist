class AppointmentsController < ApplicationController
	def index
		@appointments = current_user_patient.appointments
	end
	def index_pending
		@appointments  = current_user_patient.appointments.pending
	end

	def index_confirmed
		@appointments = current_user_patient.appointments.confirmed
	end

	def index_given
		@appointments = current_user_patient.appointments.given
	end
end
