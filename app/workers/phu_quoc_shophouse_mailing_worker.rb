class PhuQuocShophouseMailingWorker
  include Sidekiq::Worker
  PLAN_NAME = "phu_quoc_shophouse"
  sidekiq_options queue: "#{ENV['ACTIVE_JOB_QUEUE_PREFIX']}_#{PLAN_NAME}_#{ENV['RAILS_ENV']}_mailers"

  def perform(batch_size = 50_000)
    # destroy_jobs
    RedisMailerRunner.new(PLAN_NAME, batch_size).send_phu_quoc_plan
  end

  def destroy_jobs
    jobs = Sidekiq::ScheduledSet.new.select do |retri|
      retri.klass == self.class.name
    end
    jobs.each(&:delete)
  end
end
