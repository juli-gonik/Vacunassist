class UserVacunatorsController < ApplicationController
  before_action :set_user_vacunator, only: %i[edit update show edit_password update_password edit_vacunatorio update_vacunatorio destroy]

  def show; end

  def set_user_vacunator
    @user_vacunator = UserVacunator.find(params[:id])
  end

  def all_user_vacunators
    filter = UserVacunatorsFilter.new(filter_params)
    @vacunators = filter.call
    @vacunators = @vacunators.order(date: :desc).paginate(page: params[:page], per_page: 15)
  end

  def new_perry
    @user_vacunator = UserVacunator.new
  end

  def create_papa
    @user_vacunator = UserVacunator.new(user_vacunator_params)
    @user_vacunator.password = @user_vacunator.dni
    @user_vacunator.password_confirmation = @user_vacunator.dni
    @user_vacunator.skip_confirmation_notification!

    if @user_vacunator.save
      UserMailer.with(user_vacunator: @user_vacunator).new_user_vacunator.deliver_now
      redirect_to all_user_vacunators_user_vacunators_path, notice: 'Vacunador creado con exito'
    else
      render :new_perry
    end
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

  def edit_vacunatorio; end

  def update_vacunatorio
    if @user_vacunator.update(user_vacunator_vacunatorio_params)
      redirect_to all_user_vacunators_user_vacunators_path, notice: 'Vacunador actualizado con exito'
    else
      render :edit_vacunatorio
    end
  end

  def edit_password; end

  def update_password
    @user_vacunator = current_user_vacunator
    redirect_to @user_vacunator and return if params.dig(:user_vacunator,
                                                         :password).blank? && params.dig(:user_vacunator,
                                                                                         :current_password).blank?

    if @user_vacunator.update_with_password(user_vacunator_params)
      # Sign in the user_patient by passing validation in case their password changed
      bypass_sign_in(@user_vacunator)
      redirect_to @user_vacunator, notice: 'Contraseña actualizada con exito'
    else
      render :edit_password
    end
  end

  def destroy
    @user_vacunator.destroy
    redirect_to all_user_vacunators_user_vacunators_path, notice: 'Vacunador dado de baja'
  end

  private

  def filter_params
    params.require(:user_vacunators_filter).permit(:query, :zone) if params[:user_vacunators_filter]
  end

  def user_vacunator_without_password_params
    params.require(:user_vacunator).permit(:name, :last_name, :vacunatorio_id, :dni)
  end

  def user_vacunator_vacunatorio_params
    params.require(:user_vacunator).permit(:vacunatorio_id)
  end

  def user_vacunator_params
    params.require(:user_vacunator).permit!
  end

  def set_user_vacunator
    @user_vacunator = UserVacunator.find(params[:id])
  end
end
