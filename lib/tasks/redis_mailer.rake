namespace :redis_plan_mailer do
  task :import_email, [:plan_name] => :environment do |t, args|
    plan_name =  args.plan_name.downcase.gsub(" ", "_")
    RedisMailerRunner.new(plan_name).import_email_from_csv
  end

  task :send_email_batch_phu_quoc, [:batch_size, :plan_name] => :environment do |t, args|
    plan_name =  args.plan_name.downcase.gsub(" ", "_")
    RedisMailerRunner.new(plan_name).send_phu_quoc_plan(100)
  end
end