class CreateMarketingPlans < ActiveRecord::Migration[5.2]
  def change
    create_table :marketing_plans do |t|
      t.string :plan_name
      t.string :subject
      t.text :html_plain
      t.text :text_plain

      t.timestamps
    end
  end
end
