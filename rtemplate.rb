gem 'haml-rails'
gem 'thin'

gem_group :test do
  gem 'rspec-rails', '~> 3.1.0'
  gem "rails-erd"
  gem 'simplecov'
  gem 'shoulda-matchers'
  gem 'fabrication'
  gem 'database_cleaner'
  gem 'capybara'
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
run "rm -rf test"
run 'mkdir spec/fabricators'
run 'mkdir spec/features'
run 'mkdir spec/models'
run 'mkdir spec/controllers'

file 'README.md', <<-CODE
  <h3>Problem:</h3>
  <h3>Explanation:</h3>
  <h3>Processes:</h3>
  <h3>Data Model:</h3>
  <h3>Technical Stuff:</h3>
CODE

file 'app/controllers/home_controller.rb', <<-CODE
  class HomeController < ApplicationController
  end
CODE

file 'app/views/homes/index.html.haml', <<-CODE
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
