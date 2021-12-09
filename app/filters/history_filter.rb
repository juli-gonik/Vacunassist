# frozen_string_literal: true

class HistoryFilter < BaseFilter
  attr_accessor :zone, :query, :vaccine, :status, :date_to, :date_from

  def call
    appointments = Appointment.joins(:user_patient, :vacunatorio).pedido.where.not(status: :canceled)
    appointments = search_by_full_name(appointments)
    appointments = search_by_vacunatorio(appointments) if @zone.present?
    appointments = appointments.where(vaccine: vaccine) if @vaccine.present?
    appointments = appointments.where(status: status) if @status.present?
    unless date_from.blank? && date_to.blank?
      appointments =
        if date_from.blank? || date_to.blank?
          filter_by_date_to(appointments) if date_from.blank?
          filter_by_date_from(appointments) if date_to.blank?
        elsif date_from.present? && date_to.present?
          by_dates(appointments)
        end
    end
    appointments
  end

  private

  def search_by_full_name(appointments)
    if @query.present?
      array_part = []
      @query.split(' ').each do |part|
        part = "'%#{part}%'"
        array_part << "(
          users.name LIKE #{part} OR
          users.last_name LIKE #{part} OR
          users.dni LIKE #{part}
        )"
      end
      appointments = appointments.where(array_part.join(' AND '))
    end
    appointments
  end

  def search_by_vacunatorio(appointments)
    appointments.where(vacunatorio: { zone: zone })
  end

  def filter_by_date_from(appointments)
    date_from = @date_from&.to_date

    appointments.where("date >= ?", date_from)
  end

  def filter_by_date_to(appointments)
    date_to = @date_to&.to_date

    appointments.where("date <= ?", date_to)
  end

  def by_dates(appointments)
    date_from = @date_from&.to_date
    date_to   = @date_to&.to_date

    appointments.where(date: date_from..date_to)
  end
end
