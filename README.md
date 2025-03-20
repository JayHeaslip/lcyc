# Lake Champlain Yacht Club membership website

This site is for maintaining the membership database for LCYC.


* Ruby version - 3.3.5

* To run the test suite: rails test, rails test:system

* To check code syntax: rubocop -a
* To update gems see ~/updating-gems

  

* The site uses delayed_job to send email, the daemon will be started when creating email if it's not already running.

* This uses capistrano for deployment.

  To deploy the staging version:
  
    * bundle exec cap staging deploy
    * staging uses the master branch

  To deploy the production version:

    1. Merge in staging changes:
  
       * git co production
       * git merge master
       * check public/.htaccess --> PassengerAppEnv production
       * git ci (if needed)
       * git push origin
       * production uses the production branch

    2. bundle exec cap production deploy

 * To manually restart after making a patch:  systemctl --user restart puma_production.service
