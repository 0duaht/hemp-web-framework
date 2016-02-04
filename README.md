# Hemp
[![Build Status](https://semaphoreci.com/api/v1/projects/3124863c-96d9-4e13-933a-23ef8ea0b600/663694/badge.svg)](https://semaphoreci.com/tobi-oduah/hemp-web-framework) [![Code Climate](https://codeclimate.com/github/andela-toduah/hemp-web-framework/badges/gpa.svg)](https://codeclimate.com/github/andela-toduah/hemp-web-framework) [![Test Coverage](https://codeclimate.com/github/andela-toduah/hemp-web-framework/badges/coverage.svg)](https://codeclimate.com/github/andela-toduah/hemp-web-framework/coverage)

Hemp is a minimalistic web framework designed to understand better, how the Rails web framework works. As with Rails, Hemp is built using Ruby and follows the  Model-View-Controller design pattern. Hemp framework comes with a whittled-down ORM similar to the ActiveRecord design.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'hemp'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hemp

## Usage

Hemp, like Rails is modeled with the MVC design framework in mind. Therefore, folder structures are very similar. Models, Views, Controllers are organized in respective folders under the app directory.

To learn more about the MVC design pattern, see https://en.wikipedia.org/wiki/Model-view-controller

```
hemp_project
│   
└───app
|   └───assets
|   └───controllers
|   └───models
|   └───views
└───config
|    └─── routes.rb
|    └───application.rb
└───db
|    └───development.sqlite3
└───config.ru
```

Database storage is persisted using the SQLite3 database engine, which is the only supported database engine currently.
To view a sample web app implemeted with the Hemp framework, see https://github.com/andela-toduah/hemp_todo

## Initial Setup
The Hemp framework is built on top of Rack - a simple interface between webservers that support Ruby and Ruby frameworks. Thus, web apps built with the framework are initialized same way Rack apps are initlialized. Through a `config.ru` file, which is parsed to determine appropriate configuration settings. A sample `config.ru` is:

```ruby
require "hemp"
RACK_ROOT = __dir__

module HempTodo
  class Application < Hemp::Application
  end
end

TodoApplication = HempTodo::Application.new

TodoApplication.pot.prepare do
  resources :fellows
  get "/", to: "fellows#index"
end

Hemp::Dependencies.load_files

use Rack::Static, urls: ["/css", "/images"], root: "app/assets"
use Rack::MethodOverride
run TodoApplication

```

The first line of the sample config file requires the Hemp framework. 

The second line sets a congstant used by the framework in searching for important files. This is required in order to map locations of important components in the web application. Thus it should be set by apps built on top of Hemp.  

A sample Application class which inherits from the BaseApplication class provided by Hemp is then declared and initialized. This sample class is used to start up the web server, and inherits methods from the BaseApplication class to provide a rack-compatible response to requests. The declaration for the Application class could be moved into a separate class and then required in the config file.

On instantiating the Application class, routes need to be set. This is done in line 11 of the config file. A block with the route methods called appropriately is passed to the prepare method exposed by the application. This block is evaluated, and routes are saved for processing. The declaration for the routes could be moved into a separate class and then required in the config file.

On evaluating routes, required files need to be loaded. This is done by calling the `load_files` method of the Dependencies module, provided by Hemp. This loads current controllers/models, and adds the path to these folders to the `LOAD_PATH`.

On the last line of the config file, the application is passed to the run method, which is evaluated by Rack to start up the web application on the default port - 9292.

## Key Features

### Routing
Routing with Hemp deals with directing requests to the appropriate controllers. A sample route file is: 

```ruby
TodoApplication.pot.prepare do
  get "/", to: "fellows#index"
  get "/login", to: "sessions#login"
  post "/login", to: "sessions#create"
  resources :fellows
end
```

Hemp supports GET, DELETE, PATCH, POST, PUT requests. 

In the sample config file, the second line indicates that GET requests to the root path of the application should be handled by the `index action of the FellowsController`.

Thus an appropriate view named index.html.erb in the fellows folder is expected in the views folder. Instance variables set in the index action of the controller are passed to the Erubis template engine which renders the view.

Resources creates a REST-compatible set of routes which handles CRUD requests dealing with fellows. The declaration is equivalent to writing these set of routes:

```ruby
get "/fellows", to: "fellows#index"
get "/fellows/new", to: "fellows#new"
post "/fellows", to: "fellows#create"
get "/fellows/:id", to: "fellows#show"
get "/fellows/:id/edit", to: "fellows#edit"
patch "/fellows/:id", to: "fellows#update"
put "/fellows/:id", to: "fellows#update"
delete "/fellows/:id", to: "fellows#destroy"
```


### Models
All models to be used with the Hemp framework are to inherit from the BaseRecord class provided by Hemp, in order to access the rich ORM functionalities provided. Although not as succinct as ActiveRecord, the BaseRecord class acts as an interface between the model class and its database representation. A sample model file is provided below:

```ruby
class Fellow < Hemp::BaseRecord
  to_table :fellows
  property :id, type: :integer, primary_key: true
  property :first_name, type: :text, nullable: false
  property :email, type: :boolean, nullable: false

  create_table
end
```
The `to_table` method provided stores the table name used while creating the table record in the database. 

The `property` method is provided to declare table columns, and their attributes. The first argument to `property` is the column name, while subsequent hash arguments are used to provide information about attributes.

The `type` argument represents the data type of the column. Supported data types by Hemp are:

  * integer (for numeric values)
  * boolean (for boolean values [true or false])
  * text    (for alphanumeric values)

The `primary_key` argument is used to specify that the column should be used as the primary key of the table. If this is an integer, the value is auto-incremented by the database.

The `nullable` argument is used to specify whether a column should have null values, or not.

While creating models, the id property declaration is optional. If this is is not provided, the Hemp ORM adds it automatically, and sets it as the primary key. Thus, it should only be set if you'd like to use a different type as the primary key.

On passing in the table name, and its properties, a call should be made to the `create_table` method to persist the model to database by creating the table.


### Controllers
Controllers are key to the MVC structure, as they handle receiving requests, interacting with the database, and providing responses. Controllers are placed in the controllers folder, which is nested in the app folder.

All controllers should inherit from the BaseController class provided by Hemp to inherit methods which simplify accessing request parameters and returning responses by rendering views.

A sample structure for a controller file is:

```ruby
class FellowsController < Hemp::BaseController
  def index
    @fellows = Fellow.all
  end

  def new
  end

  def show
    fellow
    render :show_full
  end

  def destroy
    fellow.destroy
    redirect_to "/"
  end
end
```

Instance variables set by the controllers are passed to the routes while rendering responses. 

Explicitly calling `render` to render template files is optional. If it's not called by the controller action, then it's done automatically by the framework with an argument that's the same name as the action. Thus, you can decide to call `render` explicitly when you want to render a view with a name different from the action.


### Views
Currently, view templates are handled through the Tilt gem, with the Erubis template engine. See https://github.com/rtomayko/tilt for more details.

Views are mapped to actions in controllers. Thus the folder structure for storing views depends on the location of the controller/action. A view to be rendered for the new action in the SessionsController for example is saved as `new.html.erb` in the sessions folder, nested in the views folder. A sample structure for a view file is:

```erb
<div class="big-line-break"></div>
  <div class="fellow-list">
    <div class="container">
      <div class="row">
        <div class="col l3">&nbsp;</div>
        <div class="col l5">
          <form method="POST">
            <input type="text" class="white-text" name="first_name" value=<%= fellow.first_name %> />
            <input type="text" class="white-text" name="last_name" value=<%= fellow.last_name %> />
            <input type="text" class="white-text" name="email" value=<%= fellow.email %> />
            <input type="text" class="white-text" name="stack" value=<%= fellow.stack %> />
            <input name="_method" type="hidden" value="put" />
            <input type="submit" class="btn right" value="Update Fellow"/>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
```

### External Dependencies
The Hemp framework has a few dependencies. These are listed below, with links to source pages for each.

  * sqlite3     - https://github.com/sparklemotion/sqlite3-ruby
  * erubis      - https://rubygems.org/gems/erubis
  * bundler     - https://github.com/bundler/bundler
  * rake        - https://github.com/ruby/rake
  * rack        - https://github.com/rack/rack
  * rack-test   - https://github.com/brynary/rack-test
  * facets      - https://github.com/rubyworks/facets
  * minitest    - https://github.com/seattlerb/minitest
  * tilt        - https://github.com/rtomayko/tilt

## Testing

Before running tests, run the following command to install dependencies

        $ bundle install

To test the web framework, run the following command to carry out all tests:

        $ bundle exec rake

## Contributing

1. Fork it by visiting - https://github.com/andela-toduah/hemp-web-framework/fork

2. Create your feature branch

        $ git checkout -b new_feature
    
3. Contribute to code

4. Commit changes made

        $ git commit -a -m 'descriptive_message_about_change'
    
5. Push to branch created

        $ git push origin new_feature
    
6. Then, create a new Pull Request

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

