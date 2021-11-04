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

  
  def new
    @appointment = Appointment.new(vaccine: 'fiebre_amarilla')
  end

  def create
    @appointment = Appointment.new(vaccine: 'fiebre_amarilla')

    if current_user_patient.age > 60
      redirect_to root_path, alert: 'Solo se puede dar una vez '
    elsif @appointment.fiebre_amarilla 
      redirect_to root_path, alert: 'Mayores de 60 no pueden acceder a la dosis'
    else
      Appointment.create(vaccine: 'fiebre_amarilla', status: 'pending', tipo: 'pedido', user_patient: current_user_patient)
      current_user_patient.update_column(:fiebre_amarilla, true)
    end
    redirect_to appointments_path, notice: 'Vacuna creada con exito'
  end

end
