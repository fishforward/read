class AuthenticationsController < Devise::OmniauthCallbacksController

  def weibo
    omniauth_process
  end

  def qq_connect
    puts '========in============'
    omniauth_process
  end
  
  protected
  def omniauth_process
    puts '11'
    omniauth = request.env['omniauth.auth']
    puts omniauth
    authentication = Authentication.where(provider: omniauth.provider, uid: omniauth.uid.to_s).first
    puts '22'
    if authentication
      puts "11111111111111111111111"
      set_flash_message(:notice, :signed_in)
      sign_in(:user, authentication.user)
      User.find(authentication.user_id).remember_me!
      redirect_to root_path
    elsif current_user
      puts "22222222222222222222222"
      authentication = Authentication.create_from_hash(current_user.id, omniauth)
      set_flash_message(:notice, :add_provider_success)
      redirect_to root_path
    else
      puts "3333333333333333333333"
      session[:omniauth] = omniauth.except("extra")

      set_flash_message(:notice, :fill_your_email)
      redirect_to new_user_registration_url
    end
  end

  def after_omniauth_failure_path_for(scope)
    new_user_registration_path
  end
end