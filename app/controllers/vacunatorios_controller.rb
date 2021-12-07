class VacunatoriosController < ApplicationController
  before_action :set_vacunatorio, only: %i[edit update]

  def index
    @vacunatorios = Vacunatorio.all
  end

  def edit; end

  def update
    return if params.dig(:vacunatorio, :place) == @vacunatorio.place
    
    if @vacunatorio.update(params_vacunatorio)
      UserPatient.vacunatorio_patients(@vacunatorio).each do |user_patient|
        UserMailer.with(user_patient: user_patient, vacunatorio: @vacunatorio).changed_address.deliver_now
      end
      redirect_to vacunatorios_path, notice: 'Datos actualizados con exito'
    else
      redirect_to vacunatorios_path, alert: 'No puede estar vacio'
    end
  end

  private

  def set_vacunatorio
    @vacunatorio = Vacunatorio.find(params[:id])
  end

  def params_vacunatorio
    params.require(:vacunatorio).permit!
  end
end
