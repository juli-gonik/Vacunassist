class CertificatesController < ApplicationController
  before_action :set_certificate, only: [:edit, :update, :render_certificate]
  def new
    @appointment = Appointment.find(params[:appointment])
    @certificate = Certificate.new(appointment: @appointment)
  end

  def create
    @appointment = Appointment.find(params_certificate[:appointment_id])
    @certificate = Certificate.new(params_certificate)

    if @certificate.save
      @appointment.past!
      create_new_covid_appointment(@appointment) if @appointment.covid? && @appointment.dose <= 1
      redirect_to vacunator_index_appointments_path, notice: 'Planilla completada con exito'
    else
      render :new
    end
  end

  def edit
    @appointment = Appointment.find(params[:appointment])
  end

  def update
    @appointment = Appointment.find(params_certificate[:appointment_id])
    if @certificate.update(params_certificate)
      redirect_to vacunator_index_appointments_path, notice: 'Datos actualizados con exito'
    else
      render :edit
    end
  end

  def render_certificate
    @appointment = @certificate.appointment
    @user_patient = @appointment.user_patient
    respond_to do |format|
      format.pdf do
      render        template:                       'certificates/render_certificate.pdf.erb',
                    layout:                         'pdf.html',
                    pdf:                            "Certificado-#{@user_patient.last_name}",
                    orientation:                    'Landscape',
                    title:                          "Certificado",
                    encoding:                       "UTF-8",
                    page_size:                      "A4",
                    viewport_size:                  '1280x1024',
                    disposition:                    'attachment'
      end
      format.html
    end
  end

  private

  def create_new_covid_appointment(appointment)
    user_patient = appointment.user_patient

    Appointment.create(
      vaccine: 'covid',
      status: 'pending',
      tipo: 'pedido',
      user_patient: user_patient,
      dose: appointment.dose + 1
    )
  end

  def set_certificate
    @certificate = Certificate.find(params[:id])
  end

  def params_certificate
    params.require(:certificate).permit!
  end
end
