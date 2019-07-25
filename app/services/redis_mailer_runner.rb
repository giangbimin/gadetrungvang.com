require 'csv'
class RedisMailerRunner

  def initialize(plan_name)
    @plan_name = "campagn_" + plan_name.downcase.gsub(" ", "_")
  end

  def import_email_from_csv
    clean_csv
    if File.exist?(File.join(Rails.root, 'app', 'csv', "#{@plan_name}_emails.csv"))
      is_validate = true
      file_name = File.join(Rails.root, 'app', 'csv', "#{@plan_name}_emails.csv")
    else
      is_validate = false
      file_name = File.join(Rails.root, 'app', 'csv', 'data_email_not_filtered.csv')
    end
    CSV.foreach(file_name, headers: true) do |row|
      user_email = row['email'].to_s
      $redis.zadd(@plan_name, 0, user_email)
      if is_validate
        $redis.zadd(@plan_name, 0, user_email)
      elsif EmailVerifier.check(user_email)
        $redis.zadd(@plan_name, 0, user_email)
      end
    end
    p "import_completed"
  end

  def import_from_emails_list(emails)
    emails.each do |user_email|
      $redis.zadd(@plan_name, 0, user_email)
    end
  end

  def send_phu_quoc_plan(batch_size)
    ids = $redis.zrangebyscore(@plan_name, 0, 0, limit: [0, batch_size])
    delay = 0
    ids.each_slice(100) do |emails_slice|
      emails_slice.each do |email|
        PhuQuocShopHouseMailer.sent_email_to(email).deliver_later(wait_until: delay.seconds.from_now)
        $redis.zrem(@plan_name, email)
        $redis.zadd(@plan_name, 1, email)
      end
      delay += 30
    end
  end

  def self.add_tracking_email(email)
    $redis.zadd("tracking_of_" + @plan_name, 0, email)
  end

  def clean_csv
    file_name = File.join(Rails.root, 'app', 'csv', 'data_email_phuquoc.csv')
    possible_emails = []
    CSV.foreach(file_name, headers: true) do |row|
      user_email = row['email'].to_s
      begin
        possible_emails << user_email if EmailVerifier.check(user_email)
      rescue
        p "#{@plan_name} EmailVerifier false"
        next
      end
    end
    p "possible_email generated"
    CSV.open(File.join(Rails.root, 'app', 'csv', "campagn_#{@plan_name}_emails.csv"), "wb") do |csv|
      csv << ["email"]
      possible_emails.each do |email|
        csv << [email]
      end
    end
    p "#{@plan_name}_emails.csv created"
  end

  def self.new_clean_csv
    CSV.open(File.join(Rails.root, 'app', 'csv', "emails_verified.csv"), "wb") do |csv|
      csv << ["email"]
      old_emails_file = File.join(Rails.root, 'app', 'csv', 'data_email_phuquoc.csv')
      old_emails_sheet = Roo::Spreadsheet.open(old_emails_file)
      last_loop = old_emails_sheet.last_row / 10
      threads = (0..10).map do |thread_index|
        Thread.new(thread_index) do |thread_index|
          (0..last_loop).each do |loop_page|
            sheet_index = loop_page * 10 + thread_index
            if old_emails_sheet.row(sheet_index).present? && sheet_index > 1
              begin
                if EmailVerifier.check(old_emails_sheet.row(sheet_index)[0])
                  csv << old_emails_sheet.row(sheet_index)
                else
                  p "Verifier false"
                end
              rescue
                p "can't Verifier"
                next
              end
            end
          end
        end
      end
      threads.each {|t| t.join}
    end
  end
end

# https://www.rubydoc.info/github/ezmobius/redis-rb/Redis
# :with_scores => true: include scores in output
# :limit => [offset, count]
# $redis.keys
# $redis.zrangebyscore(@plan_name, 0, 0, with_scores: true)
# $redis.del(@plan_name)
# $redis.zscore(@plan_name, email)
# $redis.zrangebyscore(@plan_name, 0, 0)
# $redis.zcount(@plan_name, 0, 0)
# $redis.zcount(@plan_name, 0, -1)
# $redis.zrangebyscore(@plan_name, 0, 0, limit: [0, @batch_size])
# $redis.del(@plan_name, 0, email)
# Sau đó, để biết còn bao nhiêu email để gửi, chỉ việc mở redis console và sử dụng zcount để show nó ra.
# redis.zcount("zset", "5", "(100") Count members with score >= 5 and < 100
# redis.zcount("zset", "(5", "+inf") Count members with scores > 5