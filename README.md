##Rails 4 Template

###Description
>Installs gems and changes directory structure for how I develop rails applications. The capistrano setup is geared towards the unicorn, nginx, rvm and ubuntu setup

###Usage
>Directly from the repository:
```ruby
rails new app_name -T -D mysql -m https://raw.githubusercontent.com/vmcilwain/rails_template/tagnumber/rtemplate.rb
```
>If cloned
```ruby
rails new <b>app_name</b> -T -m rails_template/rtemplate.rb
```
>Options Explanation:
>
>-T = Do not generate test unit. Is equivalent to - -skip-test-unit.
>-D = Select the database type (MySQL)
>-m = Use template found in location [URL or FileSystem]. Is equivalent to --template=TEMPLATE


###Gems to install
Name | URL | Reason
---------|------- | ------------
therubyracer | https://rubygems.org/gems/therubyracer |
node | https://rubygems.org/gems/node |
bootstrap-sass | https://rubygems.org/gems/bootstrap-sass |
autoprefixer-rails | https://rubygems.org/gems/autoprefixer-rails |
haml-rails | https://github.com/indirect/haml-rails |
unicorn | https://rubygems.org/gems/unicorn |
jquery-turbolinks | https://github.com/kossnocorp/jquery.turbolinks |
ransack | https://github.com/activerecord-hackery/ransack |
whenever | https://rubygems.org/gems/whenever |
delayed_job_active_record | https://rubygems.org/gems/delayed_job_active_record |
daemons | https://rubygems.org/gems/daemons | needed by delayed_job
simple_auth_engine | https://github.com/vmcilwain/simple_auth_engine | My own authentication engine |
paperclip | https://rubygems.org/gems/paperclip |
aws-sdk | https://rubygems.org/gems/aws-sdk | 
httparty | https://rubygems.org/gems/httparty | API stuff |
remotipart | https://rubygems.org/gems/remotipart | JS File uploading |
will_paginate | https://rubygems.org/gems/will_paginate |
font-awesome-rails | https://rubygems.org/gems/font-awesome-rails
letter_opener |  https://rubygems.org/gems/letter_opener |
capistrano-rails | https://rubygems.org/gems/capistrano-rails |
capistrano-rvm |  https://rubygems.org/gems/capistrano-rvm |
rspec-rails | https://github.com/rspec/rspec-rails |
rails-erd | https://github.com/voormedia/rails-erd |
simplecov | https://github.com/colszowka/simplecov |
shoulda-matchers | https://github.com/thoughtbot/shoulda-matchers |
fabrication | http://www.fabricationgem.org |
database_cleaner | https://github.com/DatabaseCleaner/database_cleaner |
configuring DB Cleaner - by Avdi Grimm | http://devblog.avdi.org/2012/08/31/configuring-database_cleaner-with-rails-rspec-capybara-and-selenium/ roadie | https://github.com/Mange/roadie | Inline email styling
capybara | https://github.com/jnicklas/capybara |
vcr | https://github.com/vcr/vcr |
webmoc | https://github.com/bblimke/webmock |
selenium-webdriver | https://rubygems.org/gems/selenium-webdriver |
chromedriver-helper | https://rubygems.org/gems/chromedriver-helper |
faker | https://github.com/stympy/fake |
pry | https://github.com/pry/pry |
pry-nav | https://github.com/nixme/pry-nav |
better_errors | https://github.com/charliesome/better_errors |
yard | http://yardoc.com |
binding_of_caller | https://rubygems.org/gems/binding_of_caller |

###Directories and files to be created
####Removes
* README.rdoc

####Adds
* README.md
* spec/fabricators
* spec/features
* spec/models
* spec/controllers
* spec/spec_helper.rb
* spec/rails_helper.rb
* app/controllers/home_controller.rb
* app/views/home/index.html.haml
* app/controllers/ui_controller.rb
* app/views/ui/index.html.haml
* app/application.yml
* config/initializers/twitter.rb
* config/initializers/sendgrid.rb
* spec/support/database_cleaner.rb
* spec/support/chrome_web_driver.rb
* config/secrets.yml
* .rspec
* setup bootstrap-sass
* setup loading config/application.yml
* setup capistrano with templates in the deploy directory
* setup spec/rails_helper