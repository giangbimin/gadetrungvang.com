require 'csv'
class RedisMailerRunner

  def initialize(plan_name, batch_size = 100)
    @plan_name = "user_track_emails_#{plan_name.downcase.gsub(" ", "_")}"
    @batch_size = batch_size
  end

  def import_email
    file_name = File.join(Rails.root, 'app', 'csv', 'data_email_phuquoc.csv')
    CSV.foreach(file_name, headers: true) do |row|
      user_email =  row['email'].to_s
      $redis.zadd(@plan_name, 0, user_email)
      p user_email
      p ">>>>>>>>"
    end
    p "import_email done"
  end

  def send_phu_quoc_plan
    ids = $redis.zrangebyscore(@plan_name, 0, 0, limit: [0, @batch_size])
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