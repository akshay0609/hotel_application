require "#{Rails.root}/config/environment.rb"

namespace :hotel_app do
  desc "Get token for api access"
  task :get_user_token, [:email] do |t, args|
    raise "The user email must be specified" unless args.email
    user = User.find_by_email(args.email)
    raise "The user #{args.email} could not be found." unless user
    puts "#{user.authentication_token}"
  end

  desc "Create new user"
  task :create_user, [:first_name,:email,:password] do |t, args|
    raise "The user first name must be specified" unless args.first_name
    raise "The user email must be specified" unless args.email
    raise "The user password must be specified" unless args.password

    user = User.create(email:args.email,first_name: args.first_name,password:args.password,password_confirmation:args.password)
    raise "The user #{args.email} could not be created." unless user
    if user.valid?
      puts "User created successfully "
    else
      puts "#{user.errors.messages}"
    end

  end
end
