class HashtagsController < ApplicationController
  # before_filter :authenticate_user!

  def index
    if user_signed_in?
      @hashtags = current_user.hashtags.sort_by(&:name)
    elsif session.has_key? :session_credential_id
      user_credential = SessionCredential.find_by_session_id session[:session_credential_id]
      unless user_credential.nil?
        @hashtags = user_credential.hashtags.sort_by(&:name)
      end
    end
  end

  def show
    @hashtag_name = params[:name].downcase
    if @hashtag_name.nil?
      redirect_to notes_path
    else
      if user_signed_in?
        @notes = current_user.hashtag_notes(@hashtag_name).sort_by(&:updated_at).reverse
      elsif session.has_key? :session_credential_id
        user_credential = SessionCredential.find_by_session_id session[:session_credential_id]
        unless user_credential.nil?
          @notes = user_credential.hashtag_notes(@hashtag_name).sort_by(&:updated_at).reverse
        end
      end
    end
  end

end