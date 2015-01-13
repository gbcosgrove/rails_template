gem 'haml-rails'
gem 'thin'
gem 'jquery-turbolinks'
gem "ransack"
gem 'figaro'

gem 'letter_opener', group: [:development]

gem_group :test do
  gem 'rspec-rails'
  gem "rails-erd"
  gem 'simplecov'
  gem 'shoulda-matchers'
  gem 'fabrication'
  gem 'database_cleaner'
  gem 'capybara'
  gem 'vcr'
  gem 'webmock'
  gem 'selenium-webdriver'
end

gem_group :development, :test do
  gem 'faker'
  gem 'pry'
  gem 'pry-nav'
  gem 'better_errors'
  gem 'yard'
end

run 'bundle install'

generate 'rspec:install'

run "rm README.rdoc"
# run "rm -rf test"
run 'mkdir spec/fabricators'
run 'mkdir spec/features'
run 'mkdir spec/models'
run 'mkdir spec/controllers'

file 'README.md', <<-CODE
<h3>Details:</h3>
> This application doesn't have any details yet.

<h3>Current Phase:</h3>
<ul>
	<li>Design..In Progress</li>
	<li>Coding..Not Started</li>
	<li>Release..Not Started</li>
</ul>

<h3>Processes:</h3>
> TBD

<h3>Data Model:</h3>
> HTML tables will be listed here soon as it is built. Also attached pdf will be in the repository once it all has been decided.

<h3>Technical Stuff:</h3>
<ul>
	<li>Ruby Version: TBD</li>
	<li>Rails Version: TBD</li>
	<li>System Dependencies: TBD</li>
	<li>Confirguration: Uses SQLite3 for test and development and Postgres for production</li>
	<li>Testing: TBD</li>
	<li>Service: TBD</li>
</ul>
CODE

file 'app/controllers/home_controller.rb', <<-CODE
class HomeController < ApplicationController
end
CODE

file 'app/views/home/index.html.haml', <<-CODE
<h2>You are home!</h2>
CODE

route "root to: 'home#index'"

file 'app/controllers/ui_controller.rb', <<-CODE
class UiController < ApplicationController
   before_action do
    redirect_to root_path
  end
end
CODE

route "get 'ui(/:action)', controller: 'ui'"
