class AppointmentsController < ApplicationController
  # before_action :set_user

  def index
    @status       = params[:status]
    @appointments = current_user_patient.appointments.pedido
    return @appointments unless @status.present?

    @appointments = @appointments.where(status: @status)
  end

  def vacunator_index
    @vacunatorio = actual_user.vacunatorio
    filter = AppointmentFilter.new(filter_params)
    @appointments = filter.call(@vacunatorio).order(created_at: :desc).paginate(page: params[:page], per_page: 15)
    @count = filter.count
  end

  def reprogramar_turnos
    vacunatorio = actual_user.vacunatorio
    @appointments = Appointment.today_appointments(vacunatorio)
    @appointments.each do |appointment|
      reschedule_appointment(appointment)
    end
    redirect_to vacunator_index_appointments_path
  end

  def new
    @appointment = Appointment.new(vaccine: 'fiebre_amarilla')
  end

  def create
    @appointment = Appointment.new(params_appointment)

    if current_user_patient.age > 60
      redirect_to root_path, alert: 'Mayores de 60 no pueden acceder a la dosis'
    elsif @appointment.fiebre_amarilla
      redirect_to root_path, alert: 'Solo se puede vacunar una vez'
    else
      Appointment.create(vaccine: 'fiebre_amarilla', status: 'pending', tipo: 'pedido', user_patient: current_user_patient)
      redirect_to appointments_path, notice: 'Vacuna creada con exito'
    end
  end

  private

  def reschedule_appointment(appointment)
    Appointment.create(
      dose: appointment.dose,
      vaccine: appointment.vaccine,
      tipo: appointment.tipo,
      status: :pending,
      user_patient: appointment.user_patient
    )
    appointment.destroy
  end

  def params_appointment
    params.require(:appointment).permit!
  end

  def filter_params
    params.require(:appointment_filter).permit(:query, :vaccine) if params[:appointment_filter]
  end
end
