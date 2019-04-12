class PhuQuocShopHouseMarketingMailer < ApplicationMailer
  default from: 'vinpearl.gw@gmail.com'

  def sent_marketing_email(user, subject, text_data)
    @user = user
    @tracking_url = "https://www.google-analytics.com/collect?v=1&tid=UA-137402423-1&cid=#{user.id}&t=event&ec=ShopHouse&ea=open&dp=%2Femail%2Fmarketing&dt=ShopHouse%20Phu%20Quoc"
    mail(to: @user.email, subject: subject) do |format|
      format.html
      format.text { render plain: text_data }
    end
  end
end
