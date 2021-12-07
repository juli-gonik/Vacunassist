# frozen_string_literal: true

class UserPatientsController < ApplicationController
  before_action :set_user_patient, only: %i[edit update show edit_password update_password complete_profile handle_complete_profile request_appointment]

  def vaccine_certificates
    @patient     = current_user_patient
    @appointment = Appointment.find(params[:appointment_id])
    respond_to do |format|
      format.pdf do
        render  template: 'user_patients/vaccine_certificates.pdf.erb',
                layout: 'pdf.html',
                pdf: "Certificado-#{@patient.last_name}",
                orientation: 'Landscape',
                title: 'Certificado',
                encoding: 'UTF-8',
                page_size: 'A4',
                viewport_size: '1280x1024',
                disposition: 'attachment'
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

    if sixty?(@user_patient)
      @user_patient.vacunatorio = actual_user.vacunatorio
      @user_patient.password = @user_patient.dni
      @user_patient.password_confirmation = @user_patient.dni
      @user_patient.first_sign_in = true
      @user_patient.skip_confirmation_notification!

      if @user_patient.valid?
        @user_patient.save
        UserMailer.with(user_patient: @user_patient).new_user_patient.deliver_now
        create_fiebre_amarilla(@user_patient)
        redirect_to vacunator_index_appointments_path, notice: 'Registro exitoso, le llegará un correo para validar el email'
      else
        render :new_partial
      end
    else
      render :new_partial
    end
  end

  def update_password
    @user_patient = current_user_patient
    redirect_to @user_patient and return if params.dig(:user_patient,
                                                       :password).blank? && params.dig(:user_patient,
                                                                                       :current_password).blank?

    if @user_patient.update_with_password(user_patient_params)
      # Sign in the user_patient by passing validation in case their password changed
      bypass_sign_in(@user_patient)
      redirect_to @user_patient, notice: 'Contraseña actualizada con exito'
    else
      render :edit_password
    end
  end

  def complete_profile
    @gripe = @user_patient.appointments.build(vaccine: 'gripe', tipo: 0, status: 2)
    @covid = @user_patient.appointments.build(vaccine: 'covid', tipo: 0, status: 2)
  end

  def handle_complete_profile
    if @user_patient.update(user_patient_params)
      @user_patient.update(first_sign_in: false)
      @user_patient.appointments.each { |appointment| check_status(appointment) }
      new_covid_appointment(@user_patient)
      new_gripe_appointment(@user_patient)
      redirect_to @user_patient, notice: 'Datos actualizados con exito'
    else
      @gripe = @user_patient.appointments.select { |appointment| appointment.vaccine == 'gripe' }.first
      @covid = @user_patient.appointments.select { |appointment| appointment.vaccine == 'covid' }.first
      render :complete_profile
    end
  end

  private

  def create_fiebre_amarilla(user_patient)
    Appointment.create(
      vaccine: :fiebre_amarilla,
      status: :confirmed,
      tipo: :pedido,
      date: Date.today,
      user_patient: user_patient
    )
  end

  def sixty?(user_patient)
    return false unless user_patient_params[:birth_date].present?

    if user_patient.age >= 60
      user_patient.errors.add(:birth_date, 'No puede ser mayor de 60 para recibir vacuna de fiebre amarilla')
      false
    else
      true
    end
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

  def new_covid_appointment(user_patient)
    @covid = @user_patient.appointments.select { |appointment| appointment.vaccine == 'covid' }.last

    return unless user_patient.age >= 18 && @covid.dose < 2

    dose = @covid.dose.zero? ? 1 : 2
    user_patient.appointments.create(vaccine: 'covid', dose: dose, tipo: 1, date: @covid.date)
  end

  def new_gripe_appointment(user_patient)
    @gripe = @user_patient.appointments.select { |appointment| appointment.vaccine == 'gripe' }.last
    if @gripe.date.present?
      user_patient.appointments.create(vaccine: 'gripe', tipo: 1, date: @gripe.date) if @gripe.date < 1.year.ago
    else
      user_patient.appointments.create(vaccine: 'gripe', tipo: 1)
    end
  end

  def check_status(appointment)
    return unless appointment.tipo == 'sistema'

    case appointment.vaccine
    when 'covid'
      appointment.destroy if appointment.dose.zero? || appointment.user_patient.age <= 18
    when 'gripe'
      appointment.destroy if appointment.date.nil?
    end
  end

end
