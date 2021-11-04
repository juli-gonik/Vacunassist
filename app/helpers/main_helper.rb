module MainHelper

  def translate_status(status)
    case status
    when 'pending'
      'Pendiente'
    when 'confirmed'
      'Confirmado'
    when 'past'
      'Atendido'
    end
  end

  def show_date(appointment)
    "#{name_of_the_day(appointment)} #{day_complete(appointment)}"
  end

  def name_of_the_day(appointment)
    t(appointment.last_dose_date.strftime('%A').downcase.to_sym, scope: [:date])
  end

  def day_complete(appointment)
    appointment.last_dose_date.strftime('%d/%m/%Y')
  end

  def appointment_date(appointment)
    return 'Pendiente a confirmación' if appointment.pending?
    return '-' if appointment.past? && (appointment.covid? && appointment.dose.zero? || appointment.last_dose_date.blank?)
    return show_date(appointment) if appointment.past?
  end
end
