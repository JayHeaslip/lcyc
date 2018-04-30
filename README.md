# Lake Champlain Yacht Club membership website

This site is for maintaining the membership database for LCYC.


* Ruby version - 2.3.7

* To run the test suite: rake test, rake test:system

* The site uses delayed_job to send email, the daemon will be started when creating email if it's not already running.

* This uses capistrano for deployment.

  To deploy the staging version: bundle exec cap staging deploy

  To deploy the production version:

  1. Merge in staging changes:
  *git co production
  *git merge master
  *git push origin

  2. bundle exec cap production deploy
