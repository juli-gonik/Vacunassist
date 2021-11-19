class UserVacunatorsController < ApplicationController
    before_action :set_user_vacunator, only: [:edit, :update, :show, :edit_password, :update_password  ] 
    
    def show; end

    def set_user_vacunator
        @user_vacunator = UserVacunator.find(params[:id])
    end

  	def edit; end

 		def update
			@user_vacunator = current_user_vacunator

			if @user_vacunator.update(user_vacunator_without_password_params)
				redirect_to @user_vacunator, notice: 'Datos actualizados con exito'
			else
				render :edit
			end
  	end

		def edit_password; end

		def update_password
			@user_vacunator = current_user_vacunator
			redirect_to @user_vacunator and return if params.dig(:user_vacunator, :password).blank? && params.dig(:user_vacunator, :current_password).blank?

			if @user_vacunator.update_with_password(user_vacunator_params)
				# Sign in the user_patient by passing validation in case their password changed
				bypass_sign_in(@user_vacunator)
				redirect_to @user_vacunator, notice: 'Contraseña actualizada con exito'
			else
				render :edit_password
			end
		end

	private

  def user_vacunator_without_password_params
    params.require(:user_vacunator).permit(:name, :last_name, :vacunatorio_id, :dni)
  end

  def user_vacunator_params
    params.require(:user_vacunator).permit!
  end

  def set_user_vacunator
    @user_vacunator = UserVacunator.find(params[:id])
  end
end