class ExampleMailer < ApplicationMailer
  default from: 'vinpearl.gw@gmail.com'

  def sample_email(user)
    @user = user
    mail to: @user.email, subject: 'Anh Chị xem hd này nhé!'
  end
end
