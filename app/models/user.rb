class User < ApplicationRecord
  def self.create_user_from_file
    require 'csv'
    csv_text = File.read(File.join(Rails.root, 'app', 'csv', 'data_email_phuquoc.csv'))
    csv = CSV.parse(csv_text, headers: true)
    csv.each do |row|
      User.create!(row.to_hash)
    end
  end
end
