class UserMailer < ApplicationMailer
    default from: 'notifications@example.com'
  
    #As non register user, you will recive this email to confirm the email adress
    def email_check
      @user = params[:user]
      @url  = 'http://example.com/login'
      mail
        (
          to: @user.email, 
          subject: 'Confirmacion de correo electronico: ' 
        )
    end

    #As register user, you will recive this email with your data and the security key
    def signup_check
      @user = params[:user]
      @url  = 'http://example.com/login'
      mail
        (
          to: @user.email, 
          subject: 'Clave de vacunacion: ' 
        )
    end
  end
  