gem 'haml-rails'
gem 'thin'
gem 'jquery-turbolinks'
gem "ransack"
gem 'figaro'
gem 'rufus-scheduler'


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
###Details
> This application doesn't have any details yet.

###Development Phases
Current Phase
-------------
Design..In Progress
Coding..Not Started
Release..Not Started

###Processes
> TBD

###Data Model
> HTML tables will be listed here soon as it is built. Also attached pdf will be in the repository once it all has been decided.

###Technical Stuff
------------------
Ruby Version | TBD
Rails Version | TBD
Dependencies | TBD
DB Configuration | TBD
Testing | TBD
Services | TBD
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
    redirect_to :root if Rails.env.production?
  end
end
CODE

route "get 'ui(/:action)', controller: 'ui'"

file 'app/views/ui/index.html.haml', <<-CODE
%section.ui-index
  %ul
    - Dir.glob('app/views/ui/*.html.haml').sort.each do |file|
      - wireframe = File.basename(file,'.html.haml')
      -  unless wireframe == 'index' || wireframe.match(/^_/)
        %li= link_to wireframe.titleize, action: wireframe unless wireframe == 'index'
CODE
