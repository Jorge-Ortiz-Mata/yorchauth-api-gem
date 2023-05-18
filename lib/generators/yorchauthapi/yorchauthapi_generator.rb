class YorchauthapiGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def options_from_command
    option = @name.downcase

    if option.eql? 'install'
      user_authentication_configuration
    else
      p 'Wrong parameter. Try with: rails g yorchauth user'
    end
  end

  private

  def user_authentication_configuration
    mount_controller_files
    mount_model_files
    mount_migration_files
    mount_yorchauthapi_routes
  end

  def mount_controller_files
    copy_file './controllers/authenticated_controller.rb', 'app/controllers/api/authenticated_controller.rb'
    copy_file './controllers/users_controller.rb', 'app/controllers/api/v1/users_controller.rb'
    copy_file './controllers/sessions_controller.rb', 'app/controllers/api/sessions_controller.rb'
  end

  def mount_model_files
    copy_file './models/user.rb', 'app/models/user.rb'
    copy_file './models/authentication_token.rb', 'app/models/authentication_token.rb'
  end

  def mount_migration_files
    copy_file './db/create_users_table.rb', "db/migrate/#{Time.now.strftime('%Y%m%d%H%M%S').to_i + 1}_create_users.rb"
    copy_file './db/create_authentication_tokens_table.rb', "db/migrate/#{Time.now.strftime('%Y%m%d%H%M%S')}_create_authentication_tokens.rb"
  end

  def mount_yorchauthapi_routes
    route 'resources :users, except: %i[index new edit]'
    route "post '/login', to: 'sessions#login'"
    route "delete '/logout', to: 'sessions#logout'"
  end
end
