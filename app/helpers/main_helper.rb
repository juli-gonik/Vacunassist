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

  def translate_status_dos(status)
    case status
    when 'pending'
      'pendientes'
    when 'confirmed'
      'confirmados'
    when 'past'
      'atendidos'
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

  def pretty_date(date)
    date.strftime('%d/%m/%Y')
  end

  def appointment_date(appointment)
    return 'Cancelado' if appointment.canceled?
    return 'Pendiente a confirmación' if appointment.pending?
    return show_date(appointment) if appointment.pedido? && (appointment.confirmed? || appointment.past?)

    '-'
  end

  def link_header(title, url)
    link_to url, class: 'nav-link text-success' do
      tag.span title, class: "#{'selected_tab' if current_page?(url, status: params[:status], check_parameters: true)}"
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

  def sort_link(column:, label:)
    if column == params[:column]
      link_to(label, list_appointments_path(column: column, direction: next_direction), class:'text-success')
    else
      link_to(label, list_appointments_path(column: column, direction: 'asc'), class:'text-success')
    end
  end

  def next_direction
    params[:direction] == 'asc' ? 'desc' : 'asc'
  end

  def sort_indicator
    tag.span(class: "sort sort-#{params[:direction]}")
  end
end
