class User < ApplicationRecord
  def self.create_user_from_file
    require 'csv'
    csv_text = File.read(File.join(Rails.root, 'app', 'csv', 'data_email_phuquoc.csv'))
    csv = CSV.parse(csv_text, headers: true)
    csv.each do |row|
      row_to_hash = row.to_hash
      retry_times = 2
      begin
        email_verified = EmailVerifier.check(row_to_hash['email'])
        email_verified ? User.create!(row_to_hash) : next
        retry_times -= 1
      rescue
        retry if retry_times > 0
        next
      end
    end
  end
end
