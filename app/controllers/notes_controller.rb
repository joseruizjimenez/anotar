class NotesController < ApplicationController

  def index
    user_signed_in?
  end

  def create
    if user_signed_in?
      new_note = @user.notes.create(params[:note])
      new_note.set_title_from_text!
      new_note.hashtags= @new_note.parse_hashtags.map { |t| t.hits += 1; t }
      @user.save
    else
      asdf
    end
  end

end