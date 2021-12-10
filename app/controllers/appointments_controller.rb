class AppointmentsController < ApplicationController
  # before_action :set_user
  before_action :set_appointment, only: [:assign_appointment, :cancel_appointment, :assign_covid_under_sixty, :ask_for_new_appointment]

  def index
    @status       = params[:status]
    @appointments = current_user_patient.appointments.pedido

    # create_new_gripe(@appointments.gripe.last) if @appointments.gripe.last.date < 1.year.ago
    return @appointments unless @status.present?

    @appointments = @appointments.where(status: @status)
  end

  def vacunator_index
    @vacunatorio = actual_user.vacunatorio
    filter = AppointmentFilterWithVacunatorio.new(filter_with_vacunatorio_params)
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

  def all_appointments
    @status = params[:status] if params[:status].present?
    @status = params[:appointments_filter][:status] if params.dig(:appointments_filter, :status).present?
    filter = AppointmentsFilter.new(filter_params)
    @appointments = filter.call
    @appointments = @appointments.where(status: @status).order(date: :desc).paginate(page: params[:page], per_page: 15)
  end

  def assign_appointment
    date =
      case @appointment.vaccine
      when 'covid'
        7.days.from_now
      when 'fiebre_amarilla'
        6.month.from_now
      when 'gripe'
        assign_gripe(@appointment)
      end
    date += 1.day if date.sunday?
    update_and_send_email(@appointment, date)
    redirect_to all_appointments_appointments_path(status: :confirmed), notice: 'Turno asignado con exito'
  end

  def cancel_appointment
    @appointment.canceled!
    UserMailer.with(appointment: @appointment).canceled_appointment.deliver_now
    redirect_to all_appointments_appointments_path(status: :pending), notice: 'Turno cancelado'
  end

  def assign_covid_under_sixty
    date = params.dig(:appointment, :date)
    if date.blank?
      redirect_to all_appointments_appointments_path(status: :pending), alert: 'Fecha no puede estar en blanco'
    else
      update_and_send_email(@appointment, date)
      redirect_to all_appointments_appointments_path(status: :confirmed), notice: 'Turno asignado con exito'
    end
  end

  def ask_for_new_appointment
    reschedule_appointment(@appointment)
    redirect_to appointments_path(status: :pending), notice: 'Turno creado'
  end

  def historial_de_turnos
    filter = HistoryFilter.new(history_filter)
    @appointments = filter.call
  end

  def list
    filter = HistoryFilter.new(history_filter)
    appointments = filter.call.order("#{params[:column]} #{params[:direction]}")
    render(partial: 'appointments', locals: { appointments: appointments })
  end



  def amount_appointments
    @hola = consultar_params.blank?
    filter = ConsultarFilter.new(consultar_params)
    @appointments = filter.call
  end


  private

  def update_and_send_email(appointment, date)
    appointment.update(date: date)
    appointment.confirmed!
    UserMailer.with(appointment: appointment).assigned_appointment.deliver_now
  end

  def assign_gripe(appointment)
    user_patient = appointment.user_patient
    if user_patient.age <= 60
      6.months.from_now
    else
      3.months.from_now
    end
  end

  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

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

  def filter_with_vacunatorio_params
    params.require(:appointment_filter_with_vacunatorio).permit(:query, :vaccine) if params[:appointment_filter]
  end

  def filter_params
    params.require(:appointments_filter).permit(:query, :vaccine, :status) if params[:appointments_filter]
  end

  def consultar_params
    params.require(:consultar_filter).permit(:zone, :date) if params[:consultar_filter]
  end

  def create_new_appointment(appointment)
    Appointment.create(
      dose: appointment.dose,
      vaccine: appointment.vaccine,
      tipo: appointment.tipo,
      status: :pending,
      user_patient: appointment.user_patient
    )
  end

  def history_filter
    params.permit(:query, :zone, :vaccine, :status, :date_to, :date_from)
  end
end
