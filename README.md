# Variating Landing Page Management Tool

Have many similar landing pages for different languages, regions, occasions?

With landing_tool you can easily manage them all in groups:

* in your landing page HTML/CSS/JavaScript source files replace all specific details with appropriate options like
  * {{city_name}}
  * {{call_to_action}}
  * {{Google_Analytics_UID}}
  * etc.
* create a new landing page entry and supply the template Zip package
* for each landing page, create variation entries by simply supplying custom values for your options specified in step 1
* profit!

## Installation

Add landing_tool to your Gemfile:

```ruby
gem 'landing_tool'
```

Install and run migrations:

```console
bundle exec rake landing_tool:install:migrations
bundle exec rake db:migrate
```

Mount it in routes.rb:

```ruby
mount LandingTool::Engine => '/landings'
```

Boot your app

 ```console
 bundle exec rails s
 ```

and tool should now be available at http://localhost:3000/landings

## Deployment

landing_tool uses paperclip to store template packages and stores compiled templates in public/landing-tool tree, so consider symlinking 'public/system' and 'public/landing-tool' to some permanent storage in your production environment

## TODO

* weaken gem dependencies
* restrict access to managing pages
* inline template files editor
* allow configuring public/landing-tool path