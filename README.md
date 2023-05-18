# Yorchauthapi
The Yorchauthapi gem allows users to authenticate on Rails API's applications.
It generates the following files:

- Controllers.
- Models.
- Migrations.

## Installation
Add this line to your application's Gemfile:

```ruby
# A ruby implementation of the RFC 7519 OAuth JSON Web Token (JWT) standard.
gem 'jwt'

<<<<<<< HEAD
# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem 'bcrypt'

# Ruby gem located at GitHub servers.
=======
gem "bcrypt", "~> 3.1.7"

>>>>>>> f262f027b99313993776e44d86315e51f4832415
gem "yorchauthapi", github: 'Jorge-Ortiz-Mata/yorchauth-api-gem'

# This configuration is for running the gem installed locally
# gem "yorchauthapi", path: '../../../rails/rails-gems/yorchauthapi'
```

And then execute:
```bash
$ bundle
```

## Getting started

This gem process all the authentication logic inside of this gem.
Run the following command to generate the files required.

This command will show you information about the current available commands.
```bash
$ rails g yorchauthapi --help
```

In order to install and generate the authentication configuration, run this command:
```bash
$ rails g yorchauthapi install
```
<<<<<<< HEAD
=======

This command will generate the following files:
- The Authenticated Controller.
- The User and the Authentication Token models.

This command will generate two migrations (These migrations will create the users and the authentication token tables).
```
$ rails yorchauthapi:install:migrations
```
>>>>>>> f262f027b99313993776e44d86315e51f4832415

Finally, create and run the migrations:
```bash
$ rails db:create db:migrate
```

<<<<<<< HEAD
In order to implement this ruby gem and avoid request for users no authenticated, make sure to configure these steps:

- Each controller must inherit from the AuthenticatedController.
- Add the authenticate_user method where you need user authentication
```ruby
module Api
  module V1
    class PostsController < AuthenticatedController
      before_action :authenticate_user

      def index
        @posts = Post.all

        render json: { posts: @posts }, status: :ok
      end
    end
  end
end
```

You will need to add the resources created within the API namespace:
```ruby
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :posts
      resources :users, except: %i[index new edit]
    end

    post '/login', to: 'sessions#login'
    delete '/logout', to: 'sessions#logout'
=======
That's it.  

Each controller you need user authentication should be inherit from Authenticated Controller and add the before_action method.
Example:

```ruby
module Api
  class PostsController < AuthenticatedController
    before_action :authenticate_user
    before_action :set_post, only: %i[ show update destroy ]
    
    def index
      @posts = Post.all
      render json: { posts: @posts }, status: :ok
    end
>>>>>>> f262f027b99313993776e44d86315e51f4832415
  end
end
```

Now run your rails server and please visit the wiki page where you will find more information regarding endpoints.

[Wiki - Getting Started](https://github.com/Jorge-Ortiz-Mata/yorchauth-api-gem/wiki)

## Contributing
Feel free to contribute to the development of this ruby gem. You will need to open a Pull Request to review the changes
you're making.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Author

* Jorge Ortiz
* Software engineer
* ortiz.mata.jorge@gmail.com
