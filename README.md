<h3>Rails 4 Template</h3>

<h3>Description</h3>
>Installs gems and changes directory structure for how I develop rails applications

<h3>Usage</h3>
><i>Directly from the repository:</i><br />
>
>rails new <b>app_name</b> -m https://raw.githubusercontent.com/vmcilwain/rails_template/<b>version</b>/rtemplate.rb
>
><i>If cloned</i><br />
>
>rails new <b>app_name</b> -m rails_tempalte/rtemplate.rb


<h3>Gems to install</h3>

<ul>
	<li><a href="https://github.com/indirect/haml-rails" target='blank'>haml-rails</a></li>
	<li><a href="https://github.com/macournoyer/thin" target='blank'>thin</a></li>
	<li><a href="https://github.com/rspec/rspec-rails" target='blank'>rspec-rails</a></li>
	<li><a href="https://github.com/voormedia/rails-erd" target='blank'>rails-erd</a></li>
	<li><a href="https://github.com/colszowka/simplecov" target='blank'>simplecov</a></li>
	<li><a href="https://github.com/thoughtbot/shoulda-matchers" target='blank'>shoulda-matchers</a></li>
	<li><a href="http://www.fabricationgem.org" target='blank'>fabrication</a></li>
	<li><a href="https://github.com/DatabaseCleaner/database_cleaner" target='blank'>database_cleaner</a> - <a href="http://devblog.avdi.org/2012/08/31/configuring-database_cleaner-with-rails-rspec-capybara-and-selenium/" target='blank'>configuring</a></li>
	<li><a href="https://github.com/jnicklas/capybara" target='blank'>capybara</a></li>
	<li><a href="https://github.com/stympy/faker" target='blank'>faker</a></li>
	<li><a href="https://github.com/pry/pry" target='blank'>pry</a></li>
	<li><a href="https://github.com/nixme/pry-nav">pry-nav</a></li>
	<li><a href="https://github.com/charliesome/better_errors" target='blank'>better_errors</a></li>
	<li><a href="http://yardoc.com" target='blank'>yard</a></li>
	<li><a href="https://github.com/vcr/vcr" target='blank'>VCR</a></li>
	<li><a href="https://github.com/bblimke/webmock" target='blank'>Webmock</a></li>
</ul>

<h3>Directories and files to be created</h3>
<ul>
	<li>Removes</li>
	<ul>
		<li>test</li>
		<li>README.rdoc</li>
	</ul>
	<li>Adds</li>
	<ul>
		<li>README.md</li>
		<li>spec/fabricators</li>
		<li>spec/features</li>
		<li>spec/models</li>
		<li>spec/controllers</li>
		<li>app/controllers/home_controller</li>
		<li>app/controllers/ui_controller</li>
	</ul>
</ul>