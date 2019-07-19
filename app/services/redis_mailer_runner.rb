require 'csv'
class RedisMailerRunner

  def initialize(plan_name, batch_size = 100)
    @plan_name = "user_track_emails_#{plan_name.downcase.gsub(" ", "_")}"
    @batch_size = batch_size
  end

  def import_email
    file_name = File.join(Rails.root, 'app', 'csv', 'data_email_phuquoc.csv')
    batch_counter = 0
    batch_num = 0
    emails = []
    CSV.foreach(file_name, headers: true) do |row|
      if batch_counter >= 99
        batch_num += 1
        p "batch #{batch_num} ok"
        emails.each do |email|
          $redis.zadd(@plan_name, 0, email)
        end
      end
      if batch_counter >= 100
        batch_counter = 0
        emails = []
      end
      emails << row['email'].to_s
      batch_counter += 1
    end
    p "import_email ok"
  end
end

# rake "redis_mailer:import_email['plan_name']"
# rake 'redis_mailer:send_email_batch[100]'
# $redis.del('user_track_emails_'  + plan_name)
# $redis.zrangebyscore('user_track_emails_' + plan_name, 0, 0)
# $redis.zrangebyscore('user_track_emails_' + plan_name, 0, 0, limit: [0, 5])
# $redis.zdel('user_track_emails_'  + plan_name, 0, email)
# Sau đó, để biết còn bao nhiêu email để gửi, chỉ việc mở redis console và sử dụng zcount để show nó ra.
# ZCOUNT user_track_emails 0 0
# hoặc
# ZCOUNT user_track_emails 1 1