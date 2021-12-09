class UserVacunatorsFilter < BaseFilter
  attr_accessor :query, :zone

  def call
    user_vacunators = UserVacunator.joins(:vacunatorio)
    user_vacunators = search(user_vacunators)
    user_vacunators = user_vacunators.where(vacunatorio: { zone: zone }) if @zone.present?
    user_vacunators
  end

  private

  def search(user_vacunators)
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
      user_vacunators = user_vacunators.where(array_part.join(' AND '))
    end
    user_vacunators
  end
end