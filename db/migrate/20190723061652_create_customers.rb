class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.string :email
      t.text :name
      t.text :job
      t.text :job_position
      t.text :address
      t.text :phone_number
      t.string :location
      t.string :vn_id
      t.string :birth_day
      t.integer :gender
      t.integer :income_type
      t.text :description

      t.timestamps
    end
  end
end
