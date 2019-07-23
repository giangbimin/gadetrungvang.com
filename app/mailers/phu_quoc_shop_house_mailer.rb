class PhuQuocShopHouseMailer < ApplicationMailer
  default from: 'grandworld@gadetrungvang.com'

  def sent_email_to(user_email)
    text_plan = PhuQuocShopHouse::TEXT_PLAN
    subject = PhuQuocShopHouse::CAMPAGN_NAME
    @user_email = user_email
    @tracking_url_first = "https://www.google-analytics.com/collect?v=1&tid=UA-137402423-1&cid=#{@user_email}&t=event&ec=ShopHouse&ea=open&dp=%2Femail%2Fmarketing&dt=ShopHouse%20Phu%20Quoc"
    @tracking_url_second = "https://gadetrungvang.com/phu_quoc_email_marketing/track?email=#{@user_email}"
    mail(to: user_email, subject: subject) do |format|
      format.html
      format.text { render plain: text_plan}
    end
  end
end
