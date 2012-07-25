class Note < ActiveRecord::Base

  has_and_belongs_to_many :hashtags

  attr_accessor :author_id, :title, :text, :edit_count

  validates_presence_of :author_id

  def update_title
    asdf
  end

  def update_hashtags
    self.hashtags=
  end

  def html_text
    asdf
  end

end