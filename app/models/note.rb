class Note < ActiveRecord::Base

  attr_accessible :text, :title

  validates_presence_of :author_id

end