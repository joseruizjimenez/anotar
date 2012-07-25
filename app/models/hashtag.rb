class Hashtag < ActiveRecord::Base

  attr_accessor :name, :hits

  # validates_uniqueness_of :name

end