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
Name | URL
---------|-------
haml-rails | https://github.com/indirect/haml-rails
thin | https://github.com/macournoyer/thin
jquery-turbolinks | https://github.com/kossnocorp/jquery.turbolinks
ransack | https://github.com/activerecord-hackery/ransack
rufus-scheduler | https://github.com/jmettraux/rufus-scheduler
figaro | https://github.com/laserlemon/figaro
rspec-rails | https://github.com/rspec/rspec-rails
rails-erd | https://github.com/voormedia/rails-erd
simplecov | https://github.com/colszowka/simplecov
shoulda-matchers | https://github.com/thoughtbot/shoulda-matchers
fabrication | http://www.fabricationgem.org
database_cleaner | https://github.com/DatabaseCleaner/database_cleaner
configuring DB Cleaner - by Avdi Grimm | http://devblog.avdi.org/2012/08/31/configuring-database_cleaner-with-rails-rspec-capybara-and-selenium/
capybara | https://github.com/jnicklas/capybara
faker | https://github.com/stympy/fake
pry | https://github.com/pry/pry
pry-nav | https://github.com/nixme/pry-nav
better_errors | https://github.com/charliesome/better_errors
yard | http://yardoc.com
VCR | https://github.com/vcr/vcr
Webmock | https://github.com/bblimke/webmock

###Directories and files to be created
####Removes
* README.rdoc

####Adds
* README.md
* spec/fabricators
* spec/features
* spec/models
* spec/controllers
* spec/spec_helper.r
* spec/rails_helper.rb
* app/controllers/home_controller
* app/controllers/ui_controller
