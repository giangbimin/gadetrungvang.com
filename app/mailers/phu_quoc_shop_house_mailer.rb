class PhuQuocShopHouseMailer < ApplicationMailer
  default from: 'grandworld@gadetrungvang.com'

  def sent_email_to(user_email, text_plan, subject)
    @user_email = user_email
    @tracking_url = "https://www.google-analytics.com/collect?v=1&tid=UA-137402423-1&cid=#{@user_email}&t=event&ec=ShopHouse&ea=open&dp=%2Femail%2Fmarketing&dt=ShopHouse%20Phu%20Quoc"
    mail(to: user_email, subject: subject) do |format|
      format.html
      format.text { render plain: text_plan}
    end
  end
end
