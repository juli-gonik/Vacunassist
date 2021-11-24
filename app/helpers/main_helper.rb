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

  def pretty_vaccine(vaccine)
    vaccine == 'fiebre_amarilla' ? 'Fiebre amarilla' : vaccine.capitalize
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
    return show_date(appointment) if !appointment.pending? && appointment.pedido?

    '-'
  end

  def link_header(title, url)
    link_to url, class: 'nav-link text-success' do
      tag.span title, class: "#{'selected_tab' if current_page?(url)}"
    end
  end

  def last_appointment_date(appointment)
    return '-' unless appointment.present? && appointment.date.present?

    show_date(appointment)
  end

  def last_appointment_dosis(appointment)
    return '-' unless appointment.present?

    appointment.dose
  end
end
