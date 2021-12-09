# frozen_string_literal: true

class AppointmentsFilter < BaseFilter
  attr_accessor :query, :vaccine, :status

  def call
    appointments = Appointment.joins(:user_patient).pedido
    appointments = search(appointments)
    appointments = appointments.where(vaccine: vaccine) if @vaccine.present?
    appointments
  end

  private

  def search(appointments)
    if @query.present?
      array_part = []
      @query.split(' ').each do |part|
        part = "'%#{part}%'"
        array_part << "(
          name LIKE #{part} OR
          last_name LIKE #{part} OR
          dni LIKE #{part}
        )"
      end
      appointments = appointments.where(array_part.join(' AND '))
    end
    appointments
  end
end
