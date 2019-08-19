class SimpleMailer < ActionMailer::Base
  default from: "grandworld@gadetrungvang.com"
  def mail_it(email, template)
    @email = email
    @template = template
    mail(to: email, subject: 'Simple test of AWS SES')
  end

  def mail_to(email, marketing_plan)
    return false unless EmailChecking.check(email)
    @email = email
    subject = marketing_plan.subject.to_s
    plan_name = marketing_plan.plan_name.to_s
    text_plain = marketing_plan.text_plain
    @template = marketing_plan.html_plain.html_safe
    @tracking_url_first = "https://www.google-analytics.com/collect?v=1&tid=UA-137402423-1&cid=#{@email}&t=event&ec=#{plan_name}&ea=open&dp=%2Femail%2Fmarketing&dt=#{plan_name}"
    @tracking_url_second = "http://ec2-18-139-162-14.ap-southeast-1.compute.amazonaws.com/email_tracking/track?email=#{@email}&plan_name=#{plan_name}"
    mail(to: email, subject: subject) do |format|
      format.html
      format.text { render plain: text_plain }
    end
  end
end

 # SimpleMailer.mail_to("st-3-3auqfz4npu@glockapps.com", marketing_plan).deliver_now