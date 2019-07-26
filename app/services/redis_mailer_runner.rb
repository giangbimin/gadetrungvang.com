require 'csv'
class RedisMailerRunner

  def initialize(plan_name)
    @plan_name = "campagn_" + plan_name.downcase.gsub(" ", "_")
  end

  def import_email_from_csv
    EmailChecking.clean_csv(@plan_name)
    if File.exist?(File.join(Rails.root, 'public', 'csv', "#{@plan_name}_emails.csv"))
      is_validated = true
      file_name = File.join(Rails.root, 'public', 'csv', "#{@plan_name}_emails.csv")
    else
      is_validated = false
      file_name = File.join(Rails.root, 'public', 'csv', 'data_email_not_filtered.csv')
    end
    CSV.foreach(file_name, headers: true) do |row|
      user_email = row['email'].to_s
      $redis.zadd(@plan_name, 0, user_email)
      if is_validated
        $redis.zadd(@plan_name, 0, user_email)
      else
        begin
          if EmailChecking.check(user_email)
            $redis.zadd(@plan_name, 0, user_email)
          else
            p "Verifier false"
          end
        rescue => err
          p "can't Verifier by #{err}"
          next
        end
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