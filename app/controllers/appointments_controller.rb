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
                               .where(date: Date.today)
                               .pedido
                               .where(user_patient: { vacunatorio: vacunatorio })
    # @appointments  = []
    # @user_patients = UserPatient.all
    # @appointments << @user_patients.each { |up| up.appointments.where(date: Date.today) }
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

  def params_appointment
    params.require(:appointment).permit!
  end
end
