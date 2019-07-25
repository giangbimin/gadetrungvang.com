class EmailCrawlerWorker
  include Sidekiq::Worker
  def perform
    RedisMailerRunner.new_clean_csv
  end
end