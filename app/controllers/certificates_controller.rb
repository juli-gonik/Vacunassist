class CertificatesController < ApplicationController
  def new
    @appointment = Appointment.find(params[:appointment])
    @certificate = Certificate.new(appointment: @appointment)
  end

  def create
    @appointment = Appointment.find(params_certificate[:appointment_id])
    @certificate = Certificate.new(params_certificate)

    if @certificate.save
      redirect_to vacunator_index_appointments_path, notice: 'Planilla completada con exito'
    else
      render :new
    end
  end

  private

  def params_certificate
    params.require(:certificate).permit!
  end
end
