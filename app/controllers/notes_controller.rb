class NotesController < ApplicationController

  def index
    if user_signed_in?
      @notes = current_user.notes
    elsif session.has_key? :session_credential_id
      user_credential = SessionCredential.find_by_session_id session[:session_credential_id]
      unless user_credential.nil?
        user_credential.increment! :visits
        @notes = Note.find_all_by_author_id :author_id => user_credential.author_id
      end
    end
  end

  def create
    if user_signed_in?
      @notes = current_user.notes
      new_note = current_user.notes.create(params[:note])
      if current_user.save
        flash[:notice] = "Your note was added succesfully!"
      else
        flash[:alert] = "Oops! Something went wrong... please try again"
        @notes = current_user.notes
        @old_text = new_note.text
      end
    else
      if session.has_key?(:session_credential_id)
        user_credential = SessionCredential.find_by_session_id(session[:session_credential_id])
      end
      if user_credential.nil?
        user_credential = SessionCredential.create
        session[:session_credential_id] = user_credential.session_id
      end
      if !user_credential.new_record?
        @notes = Note.find_all_by_author_id :author_id => user_credential.author_id
        new_note = Note.create(:author_id => user_credential.author_id, :text => params[:note])
        if !new_note.new_record?
          flash[:notice] = "Success! Sing up and we'll add your notes to the account"
          @notes.push new_note
        else
          flash[:alert] = "Oops! Something went wrong... please try again"
          @old_text = new_note.text
        end
      else
        flash[:alert] = "Oops! Something went wrong... please try again"
        @old_text = new_note.text
      end
    end
    render :index
  end

  def edit
    if user_signed_in?
      @note = current_user.notes.find params[:id]
    elsif session.has_key? :session_credential_id
      user_credential = SessionCredential.find_by_session_id session[:session_credential_id]
      unless user_credential.nil?
        @note = Note.where :author_id => user_credential.author_id, :id => params[:id]
      end
    end
    if @note.nil?
      flash[:alert] = "Oops! Note not found!"
      redirect_to notes_path
    end
  end

  def update
    if user_signed_in?
      @note = current_user.notes.find params[:id]
    elsif session.has_key? :session_credential_id
      user_credential = SessionCredential.find_by_session_id session[:session_credential_id]
      unless user_credential.nil?
        @note = Note.where :author_id => user_credential.author_id, :id => params[:id]
      end
    end
    if @note.nil?
      redirect_to notes_path
    else
      if @note.update_attributes params[:note]
        flash[:notice] = "Your note was edited succesfully!"
        render :show
      else
        flash[:alert] = "Oops! Something went wrong... please try again"
        render :edit
      end
    end
  end

  def show
    if user_signed_in?
      @note = current_user.notes.find params[:id]
    elsif session.has_key? :session_credential_id
      user_credential = SessionCredential.find_by_session_id session[:session_credential_id]
      unless user_credential.nil?
        @note = Note.where :author_id => user_credential.author_id, :id => params[:id]
      end
    end
    if @note.nil?
      redirect_to notes_path
    end
  end

end