class EmailByCsvWorker
  include Sidekiq::Worker
  sidekiq_options queue: "#{ENV['ACTIVE_JOB_QUEUE_PREFIX']}_#{ENV['RAILS_ENV']}_mailer"

  def perform(csv, plan)
    emails_sheet = Roo::Spreadsheet.open(csv)
    last_loop = emails_sheet.last_row / 10
    sheet_index = Mutex.new
    emails = []
    threads = (0..9).map do |thread_index|
      Thread.new(thread_index) do |thread_index|
        (0..last_loop).each do |loop_page|
          sheet_index = loop_page * 10 + thread_index
          if emails_sheet.row(sheet_index)[0].present? && sheet_index > 1
            begin
              p "#{sheet_index} #{emails_sheet.row(sheet_index)}"
              if EmailChecking.check(emails_sheet.row(sheet_index)[0])
                emails << emails_sheet.row(sheet_index)[0]
              else
                p "Verifier false"
              end
            rescue => err
              p "can't Verifier"
              p err
              next
            end
          end
        end
      end
    end
    threads.each { |t| t.join }
    emails.uniq.each do |email|
      SimpleMailer.mail_to(email, plan).deliver_later
    end
  end
end
