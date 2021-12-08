class UserVacunatorsFilter < BaseFilter
    attr_accessor :query
  
    def call
      user_vacunators = UserVacunator.all
      user_vacunators = search(user_vacunators)
      #user_vacunators = vacunators.where(vaccine: vaccine) if @vaccine.present?
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