# frozen_string_literal: true

class ConsultarFilter < BaseFilter
  attr_accessor :date, :zone

  def call
    appointments = Appointment.joins(:user_patient, :vacunatorio).pedido.confirmed
    appointments = appointments.where(vacunatorio: { zone: zone }) if @zone.present?
    appointments = appointments.where(date: date) if @date.present?
    appointments
  end
end
