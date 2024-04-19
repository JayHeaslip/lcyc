namespace :chores do
  desc "Backup users, rights, roles, rights_roles, roles_users"
  task backup_users: :environment do
    user, pw, db, home = get_db_config
    mysqlopts = "-Q --add-drop-table --add-locks=FALSE --lock-tables=FALSE"
    tables = "users rights roles rights_roles roles_users"
    sh "mysqldump -u#{user} -p#{pw} #{mysqlopts} #{db} #{tables} | gzip -c > #{home}/#{db}.users.sql.gz"
  end

  desc "Restore users, rights, roles, right_roles, roles_users"
  task restore_users: :environment do
    user, pw, db, home = get_db_config
    sh "gunzip <#{home}/#{db}.users.sql.gz | mysql -u#{user} -p#{pw} #{db}"
  end

  desc "Run daily chore (usually done as a cron job)"
  task daily: :environment do
    require "mail_robot"
    chore("Daily") do
      user, pw, db, home = get_db_config

      # clear sessions older than 24 hours
      # ActiveRecord::SessionStore::Session.delete_all ['updated_at < ?', 24.hours.ago]

      # backup the database and mail a copy to my gmail account
      # verbose(false)
      sh "mysqldump -h mysql.lcyc.info -u #{user} --password=#{pw} --no-tablespaces #{db} | gzip -c > #{home}/#{db}.sql.gz"
      verbose(true)
      MailRobot.dbbackup("#{home}/#{db}.sql.gz").deliver_now

      # rotate logs
      sh "/usr/sbin/logrotate -s #{home}/logrotate.state ./logrotate.conf"
    end
  end

  desc "Dump roles/rights"
  task dump_rights: :environment do
    Role.all.each do |role|
      File.open("#{Rails.root}/#{role.name}.rights", "w") do |f|
        role.rights.each do |r|
          f.puts "\"#{r.controller}\",\"#{r.action}\""
        end
      end
    end
  end

  desc "Dump rights"
  task dump_all_rights: :environment do
    File.open("#{Rails.root}/all_rights", "w") do |f|
      Right.find(:all).each do |right|
        f.puts "\"#{right.controller}\",\"#{right.action}\""
      end
    end
  end

  desc "Load rights"
  task load_all_rights: :environment do
    f = File.open("#{Rails.root}/all_rights")
    f.each do |l|
      if l =~ /"(\S+)","(\S+)"/
        right = Right.find_by_controller_and_action($1, $2)
        unless right
          Right.create(name: "#{$1}_#{$2}", controller: $1.to_s, action: $2.to_s)
        end
      end
    end
  end

  desc "Load roles/rights"
  task load_rights: :environment do
    Dir.glob("#{Rails.root}/*.rights").each do |f|
      role = Role.find_by_name(File.basename(f, ".rights"))
      role.rights = []
      File.open(f).each do |l|
        if l =~ /"(\S+)","(\S+)"/
          right = Right.find_by_controller_and_action($1, $2)
          role.rights << right if right
        end
      end
      role.save!
    end
  end

  def chore(name)
    puts "#{name} Task Invoked: #{Time.now}"
    yield
    puts "#{name} Task Finished: #{Time.now}"
  end

  def get_db_config
    db_config_hash = ActiveRecord::Base.configurations.find_db_config(Rails.env).configuration_hash
    [db_config_hash[:username],
     db_config_hash[:password],
     db_config_hash[:database],
     ENV["HOME"]]
  end
end
