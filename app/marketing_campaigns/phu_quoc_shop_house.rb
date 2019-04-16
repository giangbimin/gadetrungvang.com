class PhuQuocShopHouse
  CAMPAGN_NAME = 'Gửi Quý Khách bản thảo sơ bộ chương trình'.freeze
  TEXT_PLAN = 'Gửi Quý Khách bản thảo sơ bộ chương trình
  SHOP & CONDOTEL
  GRAND WORLD PHÚ QUỐC
  VỊ TRÍ ĐỘC TÔN - CÓ MỘT KHÔNG HAI

  * Nơi du khách thỏa mình trong những tiện ích "all-in-one"
  * Nơi sở hữu những khu vui chơi - giải trí hàng đầu khu vực và thế giới
  * Nơi mà ai ai cũng đều muốn check-in một lần trong đời

  SHOP
  * Hỗ trợ tiền thuê 2 năm + Tặng gói nội thất
  * Vận hành, quản lý bởi Vincom Retail
  * Tính thanh khoản cao, tiềm năng tăng giá vô hạn định
  Sở hữu chỉ với 4 Tỷ VNĐ
  đăng kí tại: https://gadetrungvang.com

  MINI HOTEL
  * Diện tích lớn từ 400m2 > 1.000 m2
  * Xây dựng tự do
  * Số lượng giới hạn (70 lô)
  Giá trị cao Số lượng có hạn
  đăng kí tại: https://gadetrungvang.com

  CONDOTEL
  * Chia sẻ lợi nhuận 85/15 trọn đời
  * Vốn đầu tư ít ỏi – 40% Giá Trị Căn Hộ
  * Kinh doanh hiệu quả, tăng giá liên tục vì cạnh Casino Quốc Tế
  Sở hữu chỉ với 600 Triệu VNĐ
  đăng kí tại: https://gadetrungvang.com

  THÔNG TIN LIÊN HỆ:
  CALL: 0918280511
  WEBSITE: https://gadetrungvang.com
  '.freeze
  include Base

  def sent_user_marketing_email_by_user(from_id = 1, to_id = 50_000)
    @campaign_name = PhuQuocShopHouse::CAMPAGN_NAME
    @text_content = PhuQuocShopHouse::TEXT_PLAN
    @users = User.where('id > ?', from_id).where('id < ?', to_id) if @users.blank?
    @users.each do |user|
      PhuQuocShopHouseMarketingMailer.sent_marketing_email(user, @campaign_name, @text_content).deliver_now
    end
  end
end
