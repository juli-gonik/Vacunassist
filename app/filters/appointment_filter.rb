# frozen_string_literal: true

class AppointmentFilter < BaseFilter
  attr_accessor :query
  attr_accessor :vaccine
  attr_accessor :count

  def call(vacunatorio)
    appointments = Appointment.all
    appointments = appointments.joins(:user_patient).where(user_patient: { vacunatorio: vacunatorio }).pedido.where(date: DateTime.current.midnight)
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
