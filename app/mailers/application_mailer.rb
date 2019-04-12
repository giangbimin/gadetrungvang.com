# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'grandworld@gadetrungvang.com'
  layout 'mailer'
end
