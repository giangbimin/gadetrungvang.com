class CustomerImport
  COLUMNS = %w(gender job_position birth_day income_type address phone_number name job location vn_id description)
  DEFAULT_MAPPING = {
    "gender" => :gender,
    "job_position" => :job_position,
    "birth_day" => :birth_day,
    "income_type" => :income_type,
    "address" => :address,
    "phone_number" => :phone_number,
    "name" => :name,
    "job" => :job,
    "location" => :location,
    "vn_id" => :vn_id,
    "description" => :description
  }
  def initialize(file_name, map_columns = CustomerImport::DEFAULT_MAPPING)
    @map_columns = map_columns
    @file_name = file_name
  end
 
  def perform
    return false if File.exist?(@file_name)
    p "start import customers"
    items = []
    spreadsheet = Roo::Spreadsheet.open(@file_name)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      data = {}
      row = [header, spreadsheet.row(i)].transpose.to_h
      row.each do |column, value|
        key = @map_columns[column]
        data[key] = value
      end
      items << Customer.new(data) if email_verifier?(data[:email])
    end
    ActiveRecord::Base.transaction do
      User.import!(items)
    end
    p "import done"
  end

  private

  def email_verifier?(email)
    return_flag = true
    if email.present?
      begin
        return_flag = false unless EmailVerifier.check(email)
      rescue => err
        p err
        return_flag = false
      end
    end
    return_flag
  end
end
