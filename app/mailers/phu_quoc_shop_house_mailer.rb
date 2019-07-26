class PhuQuocShopHouseMailer < ApplicationMailer
  default from: 'dungpham@gadetrungvang.com'

  def sent_email_to(user_email)
    text_plan = PhuQuocShopHouse::TEXT_PLAN
    subject = PhuQuocShopHouse::MAIl_SUBJECT
    plan_name = PhuQuocShopHouse::PLAN_NAME
    @user_email = user_email
    @tracking_url_first = "https://www.google-analytics.com/collect?v=1&tid=UA-137402423-1&cid=#{@user_email}&t=event&ec=ShopHouse&ea=open&dp=%2Femail%2Fmarketing&dt=ShopHouse%20Phu%20Quoc"
    @tracking_url_second = "http://ec2-18-139-162-14.ap-southeast-1.compute.amazonaws.com/email_tracking/track?email=#{@user_email}&plan_name=#{plan_name}"
    mail(to: user_email, subject: subject) do |format|
      format.html
      format.text { render plain: text_plan}
    end
  end
end
