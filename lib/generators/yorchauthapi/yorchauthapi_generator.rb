class YorchauthapiGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def options_from_command
    option = @name.downcase

    if option.eql? 'user'
      user_authentication_configuration
    else
      p 'Wrong parameter. Try with: rails g yorchauth user'
    end
  end

  private

  def user_authentication_configuration
    create_model_files
    create_migration_files
  end

  def create_model_files
    copy_file './models/user.rb', 'app/models/user.rb'
    copy_file './models/authentication_token.rb', 'app/models/authentication_token.rb'
  end

  def create_migration_files
    copy_file './db/create_users_table.rb', "app/db/migrate/#{Time.now.strftime('%Y%m%d%H%M%S')}_create_users.rb"
    copy_file './db/create_authentication_tokens_table.rb', "app/db/migrate/#{Time.now.strftime('%Y%m%d%H%M%S')}_create_authentication_tokens.rb"
  end
end
