# app/controllers/sso_controller.rb
class SsoController < ApplicationController
  # Ensure this endpoint skips your global restriction check 
  # so an unauthenticated visitor from Drupal can access it.
  skip_before_action :authenticate_user!, only: [:handle_sso]
  skip_before_action :check_authorization, only: [:handle_sso]

  def handle_sso
    token = params[:token]
    
    if token.blank?
      redirect_to login_path, alert: "Missing authentication token." and return
    end

    begin
      should_verify_exp = !Rails.env.development?
      
      # Fetch the shared secret key from your DDEV environment / credentials
      secret_key = Rails.application.credentials.rails_sso_secret
      if secret_key.blank?
        Rails.logger.error "SSO Critical Failure: The secret key string is returning empty/nil."
        redirect_to login_path, alert: "SSO system configuration error." and return
      end
      
      # Decode token and verify signature + expiration window
      decoded_token = JWT.decode(token, secret_key, true, { 
                                   algorithm: 'HS256',
                                   verify_expiration: should_verify_exp 
                                 })
      payload = decoded_token[0]

      email = payload['email']
      name = payload['name']

      logger.info "User email is #{email}"
      # Just-In-Time (JIT) provisioning using your explicit User model rules
      user = User.find_or_create_by!(email: email) do |u|
        if name.present?
          parts = name.split(' ', 2)
          u.firstname = parts[0]
          u.lastname = parts[1] || parts[0]
        else
          u.firstname = "SSO"
          u.lastname = "User"
        end

        u.role = Role.find_by(name: 'Member')
        # Assign a long secure random password since they use cross-app SSO
        u.password = SecureRandom.hex(32) if u.respond_to?(:password=)
      end

      # --- CUSTOM AUTHENTICATION INTEGRATION ---
      # This matches your precise method signature to build the ActiveSession database record
      # and sets session[:current_active_session_id] properly.
      login(user) 
      # -----------------------------------------

      # Send them to the application dashboard or root
      redirect_to directory_index_path, notice: "Successfully authenticated from Drupal!"

    # Temporary debug change in app/controllers/sso_controller.rb
    rescue JWT::ExpiredSignature => e
      Rails.logger.error "SSO Failure: Token has expired. #{e.message}"
      redirect_to login_path, alert: "Expired link."
    rescue JWT::DecodeError => e
      Rails.logger.error "SSO Failure: Decode error. Details: #{e.message}"
      redirect_to login_path, alert: "Invalid token."
    end
  ###rescue JWT::ExpiredSignature
  ###    redirect_to login_path, alert: "The login link has expired. Please try clicking it again from the primary site."
  ###  rescue JWT::DecodeError => e
  ###    redirect_to login_path, alert: "Authentication failed: Invalid token."
  ###  end
  end
end
