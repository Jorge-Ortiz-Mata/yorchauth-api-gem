# Yorchauthapi
The Yorchauthapi gem allows users to authenticate on Rails API's applications.
It generates the following files:

- Controllers.
- Models.
- Migrations.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'jwt'

gem 'bcrypt'

gem "yorchauthapi", github: 'Jorge-Ortiz-Mata/yorchauth-api-gem'
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

Finally, create and run the migrations:
```bash
$ rails db:create db:migrate
```

In order to implement this ruby gem and avoid request for users no authenticated, each controller must inherit from
the authenticated controller, and add the authenticate_user method
```ruby
module Api
  class PostsController < AuthenticatedController
    before_action :authenticate_user

    def index
      @posts = Post.all

      render json: { posts: @posts }, status: :ok
    end
  end
end
```

You will need to add the resources created within the API namespace:
```ruby
Rails.application.routes.draw do
  namespace :api do
    resources :users
    resources :posts
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
