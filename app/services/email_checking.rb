require 'resolv'
require 'truemail'
class EmailChecking
  def initialize(email)
    Truemail.configure do |config|
      config.verifier_email = 'verifier@example.com'
      config.whitelisted_domains = ['gmail.com', 'yahoo.com', 'yahoo.com.vn']
      config.blacklisted_domains = ['10minutesmail.com']
      config.validation_type_for = { 'somedomain.com' => :mx }
      config.smtp_safe_check = true
    end
    @email = email
  end
  
  def check
    Truemail.valid?(@email)
  end

  def self.check(email)
    EmailChecking.new(email).check
  end

  def self.clean_csv(plan_name = "")
    csv_name = plan_name.blank? ? "emails_verified" : "#{plan_name}_emails"
    CSV.open(File.join(Rails.root, 'public', 'csv', "#{csv_name}.csv"), "wb") do |csv|
      csv << ["email"]
      old_emails_file = File.join(Rails.root, 'public', 'csv', 'data_email_not_filtered.csv')
      old_emails_sheet = Roo::Spreadsheet.open(old_emails_file)
      last_loop = old_emails_sheet.last_row / 10
      threads = (0..10).map do |thread_index|
        Thread.new(thread_index) do |thread_index|
          (0..last_loop).each do |loop_page|
            sheet_index = loop_page * 10 + thread_index
            if old_emails_sheet.row(sheet_index).present? && sheet_index > 1
              begin
                p "#{sheet_index} #{old_emails_sheet.row(sheet_index)}"
                if EmailChecking.check(old_emails_sheet.row(sheet_index)[0])
                  csv << old_emails_sheet.row(sheet_index)
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
      threads.each {|t| t.join}
    end
  end
end


