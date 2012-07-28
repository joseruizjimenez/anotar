class Hashtag < ActiveRecord::Base

  attr_accessor :name, :hits, :updated_at, :created_at
  attr_accessible :name, :hits

  validates_presence_of :name
  validates_uniqueness_of :name

end