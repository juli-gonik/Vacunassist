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

  def show_date_last_dose(appointment)
    "#{name_of_the_day_last_dose(appointment)} #{day_complete_last_dose(appointment)}"
  end

  def name_of_the_day_last_dose(appointment)
    t(appointment.last_dose_date.strftime('%A').downcase.to_sym, scope: [:date])
  end

  def day_complete_last_dose(appointment)
    appointment.last_dose_date.strftime('%d/%m/%Y')
  end

  def show_date(appointment)
    "#{name_of_the_day(appointment)} #{day_complete(appointment)}"
  end

  def name_of_the_day(appointment)
    t(appointment.date.strftime('%A').downcase.to_sym, scope: [:date])
  end

  def day_complete(appointment)
    appointment.date.strftime('%d/%m/%Y')
  end

  def appointment_date(appointment)
    return 'Pendiente a confirmación' if appointment.pending?
    return show_date_last_dose(appointment) if appointment.past? && appointment.sistema?
    return show_date(appointment) if !appointment.pending? && appointment.pedido?

    '-'
  end
end
