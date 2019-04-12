# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'vinpearl.gw@gmail.com'
  layout 'mailer'
end
