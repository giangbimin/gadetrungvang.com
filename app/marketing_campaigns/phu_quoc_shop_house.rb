class PhuQuocShopHouse
  CAMPAGN_NAME = 'Gửi Quý Khách bản thảo sơ bộ chương trình'.freeze
  TEXT_PLAN = 'Gửi Quý Khách bản thảo sơ bộ chương trình'.freeze
  include Base

  def self.sent_email_from_file(part = 1, limit = 1000)
    counter = 0
    from_id = (part - 1) * limit
    to_id = part * limit
    csv_text = File.read(File.join(Rails.root, 'app', 'csv', 'data_email_phuquoc.csv'))
    csv = CSV.parse(csv_text, headers: true)
    @campaign_name = PhuQuocShopHouse::CAMPAGN_NAME
    @text_content = PhuQuocShopHouse::TEXT_PLAN
    csv.each do |row|
      counter += 1
      next if counter < from_id
      break if counter > to_id
      user = User.new(row.to_hash)
      PhuQuocShopHouseMarketingMailer.sent_marketing_email(user, @campaign_name, @text_content).deliver_now
    end
  end

  def sent_user_marketing_email_by_user(part = 1, limit = 1000)
    @campaign_name = PhuQuocShopHouse::CAMPAGN_NAME
    @text_content = PhuQuocShopHouse::TEXT_PLAN
    from_id = (part - 1) * limit
    to_id = part * limit
    @users.each do |user|
      user_id = user.id
      next if user_id < from_id
      break if user_id > to_id
      PhuQuocShopHouseMarketingMailer.sent_marketing_email(user, @campaign_name, @text_content).deliver_now
    end
  end
end
