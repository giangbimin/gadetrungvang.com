class PhuQuocMailingWorker
  include Sidekiq::Worker
  sidekiq_options queue: "#{ENV['ACTIVE_JOB_QUEUE_PREFIX']}_#{ENV['RAILS_ENV']}_mailers"

  def perform(from_line, to_line)
    return if users.blank?
    # destroy_jobs(from_line, to_line)
    PhuQuocShopHouse.send_marketing_email_with_data_from_csv(from_line, to_line)
  end

  def destroy_jobs(from_line, to_line)
    jobs = Sidekiq::ScheduledSet.new.select do |retri|
      retri.klass == self.class.name && retri.item['args'] == [from_line, to_line]
    end
    jobs.each(&:delete)
  end
end
