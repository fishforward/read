class ReadRegistrationsController < Devise::RegistrationsController

	def create
		build_resource

	    if resource.save
	      if resource.active_for_authentication?

	        set_flash_message :notice, :signed_up if is_navigational_format?
	        sign_up(resource_name, resource)

	        respond_with resource, :location => after_sign_up_path_for(resource)
	      else
	        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
	        expire_session_data_after_sign_in!
	        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
	      end
	    else
	      clean_up_passwords resource
	      respond_with resource
	    end

	end 

	def sign_up(resource_name, resource)
    	
      	sign_in(resource_name, resource)

      	## fish add start
    	omniauth = session[:omniauth]
    	if omniauth
	    	authentication = Authentication.where(provider: omniauth.provider, uid: omniauth.uid.to_s).first
	      	Authentication.create_from_hash(resource.id, omniauth) if authentication == nil
	      	set_flash_message(:notice, :add_provider_success)
	    end
      	## fish add end
  	end 

end