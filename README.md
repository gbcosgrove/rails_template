##Rails 4 Template

###Description
>Installs gems and changes directory structure for how I develop rails applications

###Usage
>Directly from the repository:
```ruby
rails new app_name -T -m https://raw.githubusercontent.com/vmcilwain/rails_template/<b>version</b>/rtemplate.rb
```
>If cloned
```ruby
rails new <b>app_name</b> -T -m rails_template/rtemplate.rb
```
>Options Explanation:
>
>-T = Do not generate test unit. Is equivalent to - -skip-test-unit.
>
>-m = Use template found in location [URL or FileSystem]. Is equivalent to --template=TEMPLATE


###Gems to install
Name | URL | Reason
---------|------- | ------------
pg | https://rubygems.org/gems/pg | For heroku
rails_12factor | https://rubygems.org/gems/rails_12factor | For Heroku
bootstrap-sass | https://rubygems.org/gems/bootstrap-sass |
autoprefixer-rails | https://rubygems.org/gems/autoprefixer-rails |
haml-rails | https://github.com/indirect/haml-rails |
puma | https://rubygems.org/gems/puma |
jquery-turbolinks | https://github.com/kossnocorp/jquery.turbolinks |
ransack | https://github.com/activerecord-hackery/ransack |
whenever | https://rubygems.org/gems/whenever |
figaro | https://github.com/laserlemon/figaro |
authenticatable | https://github.com/vmcilwain/authenticatable | My own authentication engine |
paperclip | https://rubygems.org/gems/paperclip |
aws-sdk | https://rubygems.org/gems/aws-sdk | 
httparty | https://rubygems.org/gems/httparty | API stuff |
remotipart | https://rubygems.org/gems/remotipart | JS File uploading |
will_paginate | https://rubygems.org/gems/will_paginate| 

rspec-rails | https://github.com/rspec/rspec-rails |
rails-erd | https://github.com/voormedia/rails-erd |
simplecov | https://github.com/colszowka/simplecov |
shoulda-matchers | https://github.com/thoughtbot/shoulda-matchers |
fabrication | http://www.fabricationgem.org |
database_cleaner | https://github.com/DatabaseCleaner/database_cleaner |
configuring DB Cleaner - by Avdi Grimm | http://devblog.avdi.org/2012/08/31/configuring-database_cleaner-with-rails-rspec-capybara-and-selenium/ roadie | https://github.com/Mange/roadie | Inline email styling
capybara | https://github.com/jnicklas/capybara |
faker | https://github.com/stympy/fake |
pry | https://github.com/pry/pry |
pry-nav | https://github.com/nixme/pry-nav |
better_errors | https://github.com/charliesome/better_errors |
yard | http://yardoc.com |
VCR | https://github.com/vcr/vcr |
Webmock | https://github.com/bblimke/webmock |

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
* config/initializers/twitter.rb
* spec/support/database_cleaner.rb
* spec/support/chrome_web_driver.rb
* .rspec