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

  def self.send_marketing_email_with_data_from_csv(from_line, to_line)
    campaign_name = PhuQuocShopHouse::CAMPAGN_NAME
    text_content = PhuQuocShopHouse::TEXT_PLAN
    file_name = File.join(Rails.root, 'public', 'csv', 'data_email_phuquoc.csv')
    count = 0
    CSV.foreach(file_name, headers: true) do |row|
      count += 1
      next if count < from_line || count > to_line
      puts 'exec line'
      puts '>>>>>>'
      puts count
      puts '>>>>>>'
      to_email = row['email'].to_s
      retry_times = 2
      begin
        email_verified = EmailChecking.check(to_email)
        if email_verified
          PhuQuocShopHouseMarketingMailer.sent_marketing_email(to_email, count, campaign_name, text_content).deliver_now
        else
          next
        end
        retry_times -= 1
      rescue
        retry if retry_times > 0
        next
      end
    end
  end
end
