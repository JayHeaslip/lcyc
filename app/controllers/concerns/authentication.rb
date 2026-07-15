module Authentication
  extend ActiveSupport::Concern

  included do
    # Run authentication setup as a before_action
    before_action :restore_session

    # Expose helper methods to your views
    helper_method :current_user, :user_signed_in?
  end

  # Check if a user is logged in; if not, redirect them to login
  def authenticate_user!
    unless user_signed_in?
      store_location
      redirect_to login_path, alert: "You need to login to access that page."
    end
  end

  # Handle the login process safely
  def login(user)
    reset_session
    active_session = user.active_sessions.create!(
      user_agent: request.user_agent,
      ip_address: request.ip
    )
    session[:current_active_session_id] = active_session.id

    # Memoize so Current.user is instantly accessible without another DB query
    Current.user = user
    @current_active_session = active_session

    active_session
  end

  # Delete the remember token cookie
  def forget_active_session
    cookies.delete(:remember_token)
  end

  # Destroy the active database session and clear cookies/sessions
  def logout
    forget_active_session
    current_active_session&.destroy
    reset_session
    Current.user = nil
    @current_active_session = nil
  end

  # Redirect logged-in users away from guest pages (like the login page)
  def redirect_if_authenticated
    redirect_to root_path, alert: "You are already logged in." if user_signed_in?
  end

  # Store the remember token securely in a permanent cookie
  def remember(active_session)
    cookies.permanent.encrypted[:remember_token] = active_session.remember_token
  end

  private

  # Return the current user if one is authenticated
  def current_user
    Current.user
  end

  # Helper to check if a user is logged in
  def user_signed_in?
    current_user.present?
  end

  # Restores the session from either the session store or cookies
  def restore_session
    if current_active_session
      # Update the session's activity timestamp *once* per request if it was found
      current_active_session.touch
      Current.user = current_active_session.user
    else
      Current.user = nil
    end
  end

  # Memoize the active session so it is only loaded from the DB ONCE per request
  def current_active_session
    @current_active_session ||= find_active_session
  end

  # Query the active session from either the session ID or the remember cookie
  def find_active_session
    if session[:current_active_session_id].present?
      ActiveSession.find_by(id: session[:current_active_session_id])
    elsif cookies.encrypted[:remember_token].present?
      active_session = ActiveSession.find_by(remember_token: cookies.encrypted[:remember_token])

      if active_session
        # If logging back in via cookie, re-establish the session cookie
        session[:current_active_session_id] = active_session.id
        active_session
      end
    end
  end

  # Store the URL the user attempted to access before being prompted to login
  def store_location
    if request.get? && request.local?
      session[:user_return_to] = request.original_url
    end
  end
end
