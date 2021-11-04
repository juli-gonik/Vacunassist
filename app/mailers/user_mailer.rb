class UserMailer < ApplicationMailer
    default from: 'notifications@example.com'
  
    def signup_check
      @user = params[:user]
      @url  = 'http://example.com/login'
      mail (to: @user.email, subject: 'Clave de vacunacion: ' )
    end
  end
  