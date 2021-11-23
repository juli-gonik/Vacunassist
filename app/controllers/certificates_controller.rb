class CertificatesController < ApplicationController
  before_action :set_certificate, only: [:edit, :update]
  def new
    @appointment = Appointment.find(params[:appointment])
    @certificate = Certificate.new(appointment: @appointment)
  end

  def create
    @appointment = Appointment.find(params_certificate[:appointment_id])
    @certificate = Certificate.new(params_certificate)

    if @certificate.save
      @appointment.past!
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

  private

  def set_certificate
    @certificate = Certificate.find(params[:id])
  end

  def params_certificate
    params.require(:certificate).permit!
  end
end
