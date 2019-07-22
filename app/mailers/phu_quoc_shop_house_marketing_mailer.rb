class PhuQuocShopHouseMarketingMailer < ApplicationMailer
  default from: 'dungpham@gadetrungvang.com'

  def sent_marketing_email(user_email, user_id, subject, text_data)
    @user_email = user_email
    @tracking_url = "https://www.google-analytics.com/collect?v=1&tid=UA-137402423-1&cid=#{user_id}&t=event&ec=ShopHouse&ea=open&dp=%2Femail%2Fmarketing&dt=ShopHouse%20Phu%20Quoc"
    mail(to: user_email, subject: subject) do |format|
      format.html
      format.text { render plain: text_data }
    end
  end
end
