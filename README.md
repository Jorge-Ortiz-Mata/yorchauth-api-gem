# Yorchauthapi
The Yorchauthapi gem allows users to authenticate on Rails API's applications.
All the authentication process ocurrs within the gem. It only generates the authenticated controller,
models and migrations.

## Getting Started
This gem requires JWT to send and receive the authentication tokens encrypted.
Be sure to specified this gem within your Gemfile

## Installation
Add this line to your application's Gemfile:

```ruby
gem "jwt"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

gem "yorchauthapi", github: 'Jorge-Ortiz-Mata/yorchauth-api-gem'
```

And then execute:
```bash
$ bundle
```

## How to use it.
This gem process all the authentication logic inside of this gem.
Run the following command to generate the files required.

This command will show you information about the current available commands.
```bash
$ rails g yorchauthapi --help
```

In order to install and generate the authentication configuration, run this command:
```bash
$ rails g yorchauthapi User
```
This command will generate the following files:
- The Authenticated Controller.
- The User and the Authentication Token models.
- Two migrations (These migrations will create the users and the authentication token tables).


Finally, create and run the migrations:
```bash
$ rails db:create db:migrate
```

That's it.
Now run your rails server and please visit the wiki page where you will find more information regarding endpoints.
[Wiki - Getting Started](https://github.com/Jorge-Ortiz-Mata/yorchauth-api-gem/wiki)

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


## Author

* Jorge Ortiz
* Software engineer
* ortiz.mata.jorge@gmail.com
