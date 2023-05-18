# Yorch Auth API - Ruby gem.
The Yorchauthapi gem allows users to authenticate on Rails API's applications.
It generates the following files:

- Controllers.
- Models.
- Migrations.

## Installation
Add the following gems to your Gemfile:

```ruby
# A ruby implementation of the RFC 7519 OAuth JSON Web Token (JWT) standard.
gem 'jwt'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem 'bcrypt'

# Ruby gem located at GitHub servers.
gem "yorchauthapi", github: 'Jorge-Ortiz-Mata/yorchauth-api-gem'

# This configuration is for running the gem installed locally
# gem "yorchauthapi", path: '../../../rails/rails-gems/yorchauthapi'
```

And then install them:
```bash
$ bundle
```

## Getting started

This gem will generate several files in order to authenticate users within your API application.
This command will show you information about the current available commands.
```bash
$ rails g yorchauthapi --help
```

In order to install and generate the authentication configuration, run this command:
```bash
$ rails g yorchauthapi install
```

Finally, create and run the migrations:
```bash
$ rails db:create db:migrate
```

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

You will need to add these routes within the API (and V1 if you need it) namespace:
```ruby
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :posts
      resources :users, except: %i[index new edit]
    end

    post '/login', to: 'sessions#login'
    delete '/logout', to: 'sessions#logout'
  end
end
```

Now run your rails server and start testing.

```bash
$ rails server
```

Please visit the wiki page where you will find more information regarding endpoints.

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
