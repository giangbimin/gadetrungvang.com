namespace :redis_plan_mailer do
  task :import_email, [:plan_name] => :environment do |t, args|
    plan_name =  args.plan_name.downcase.gsub(" ", "_")
    RedisMailerRunner.new(plan_name, 100).import_email
  end

  task :send_email_batch_phu_quoc, [:batch_size, :plan_name] => :environment do |t, args|
    plan_name =  args.plan_name.downcase.gsub(" ", "_")
    RedisMailerRunner.new(plan_name, 100).send_phu_quoc_plan
  end
end