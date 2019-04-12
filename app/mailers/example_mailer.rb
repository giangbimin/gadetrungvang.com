class ExampleMailer < ApplicationMailer
  default from: 'grandworld@gadetrungvang.com'

  def sample_email(user)
    @user = user
    mail to: @user.email, subject: 'Anh Chị xem hd này nhé!'
  end
end
