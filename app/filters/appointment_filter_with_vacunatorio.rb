# frozen_string_literal: true

class AppointmentFilterWithVacunatorio < BaseFilter
  attr_accessor :query, :vaccine, :count

  def call(vacunatorio)
    appointments = Appointment.today_appointments(vacunatorio)
    @count = appointments.count
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
      appointments = appointments.joins(:user_patient).where(array_part.join(' AND '))
    end
    appointments
  end
end
