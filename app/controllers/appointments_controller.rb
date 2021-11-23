class AppointmentsController < ApplicationController
  # before_action :set_user

  def index
    @appointments = current_user_patient.appointments.pedido
  end

  def index_pending
    @appointments = current_user_patient.appointments.pending.pedido
  end

  def index_confirmed
    @appointments = current_user_patient.appointments.confirmed.pedido
  end

  def index_past
    @appointments = current_user_patient.appointments.past.pedido
  end

  def vacunator_index
    vacunatorio = actual_user.vacunatorio
    @appointments = Appointment.joins(:user_patient)
                               .where(date: DateTime.current.midnight)
                               .pedido
                               .where(user_patient: { vacunatorio: vacunatorio })
    @appointments = @appointments.paginate(page: params[:page], per_page: 15)

  end

  def reprogramar_turnos
    vacunatorio = actual_user.vacunatorio
    @appointments = Appointment.joins(:user_patient)
                               .where(date: DateTime.current.midnight)
                               .pedido
                               .where(user_patient: { vacunatorio: vacunatorio })
                               .where.not(status: :past)
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
end
