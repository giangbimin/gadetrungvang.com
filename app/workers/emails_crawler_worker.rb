class EmailCrawlerWorker
  include Sidekiq::Worker
  sidekiq_options queue: "#{ENV['ACTIVE_JOB_QUEUE_PREFIX']}_#{ENV['RAILS_ENV']}_critical"

  def perform
    RedisMailerRunner.new_clean_csv
  end
end