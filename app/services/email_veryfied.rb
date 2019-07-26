require 'resolv'
class EmailVerified
  def self.validate_email_domain(email)
    domain = email.match(/\@(.+)/)[1]
    Resolv::DNS.open do |dns|
      @mx = dns.getresources(domain, Resolv::DNS::Resource::IN::MX)
    end
    @mx.size > 0 ? true : false
  end

  def self.clean_csv(plan_name = "")
    csv_name = plan_name.blank? ? "emails_verified" : "#{plan_name}_emails"
    CSV.open(File.join(Rails.root, 'public', 'csv', "#{csv_name}.csv"), "wb") do |csv|
      csv << ["email"]
      old_emails_file = File.join(Rails.root, 'public', 'csv', 'data_email_phuquoc.csv')
      old_emails_sheet = Roo::Spreadsheet.open(old_emails_file)
      last_loop = old_emails_sheet.last_row / 10
      threads = (0..10).map do |thread_index|
        Thread.new(thread_index) do |thread_index|
          (0..last_loop).each do |loop_page|
            sheet_index = loop_page * 10 + thread_index
            if old_emails_sheet.row(sheet_index).present? && sheet_index > 1
              begin
                p "#{sheet_index} #{old_emails_sheet.row(sheet_index)}"
                if EmailVerifier.check(old_emails_sheet.row(sheet_index)[0])
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


