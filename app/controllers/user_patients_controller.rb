class UserPatientsController < ApplicationController
  before_action :set_user_patient, only: [:edit, :update, :show, :edit_password, :update_password]
  def vaccine_certificates
    @patient     = current_user_patient
    @appointment = Appointment.find(params[:appointment_id])
    respond_to do |format|
      format.pdf do
        render        template:                       'user_patients/vaccine_certificates.pdf.erb',
                      layout:                         'pdf.html',
                      pdf:                            "Certificado-#{@patient.last_name}",
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

  def show; end

  def edit; end

  def update
    @user_patient = current_user_patient

    if @user_patient.update(user_patient_without_password_params)
      # Sign in the user_patient by passing validation in case their password changed
      # bypass_sign_in(@user_patient)
      redirect_to @user_patient, notice: 'Datos actualizados con exito'
    else
      render :edit
    end
  end

  def edit_password; end

  def new_partial
    @user_patient = UserPatient.new
  end

  def create_partial
    @user_patient = UserPatient.new(user_patient_params)
    @user_patient.access_key = SecureRandom.hex(4)
    sixty?(@user_patient)
    @user_patient.vacunatorio = actual_user.vacunatorio
    @user_patient.password = @user_patient.dni
    @user_patient.password_confirmation = @user_patient.dni
  
    if @user_patient.save
      create_fiebre_amarilla(@user_patient)
      redirect_to root_path, notice: 'Registro exitoso, le llegará un correo para validar el email'
    else
      render :new_partial
    end
  end

  def update_password
    @user_patient = current_user_patient
    redirect_to @user_patient and return if params.dig(:user_patient, :password).blank? && params.dig(:user_patient, :current_password).blank?

    if @user_patient.update_with_password(user_patient_params)
      # Sign in the user_patient by passing validation in case their password changed
      bypass_sign_in(@user_patient)
      redirect_to @user_patient, notice: 'Contraseña actualizada con exito'
    else
      render :edit_password
    end
  end

  private

  def create_fiebre_amarilla(user_patient)
    Appointment.create(
      vaccine: 2,
      status: 1,
      tipo: 1,
      date: Date.today,
     user_patient: user_patient
    )
  end

  def sixty?(user_patient)
    errors.add(:birth_date, 'No puede ser mayor de 60 para recibir vacuna de fiebre amarilla') if user_patient.age >= 60
  end

  def user_patient_without_password_params
    params.require(:user_patient).permit(:name, :last_name, :vacunatorio_id, :dni, :risk_patient, :birth_date)
  end

  def user_patient_params
    params.require(:user_patient).permit!
  end

  def set_user_patient
    @user_patient = UserPatient.find(params[:id])
  end

end
