class Note < ActiveRecord::Base

  has_and_belongs_to_many :hashtags

  attr_accessor :author_id, :title, :text, :html_text, :edit_count, :shared,
    :fav
  attr_accessible :text, :author_id

  validates_presence_of :author_id, :text
  after_find :init

  class NoteHelper
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::SanitizeHelper
  end

  def helper
    @h ||= NoteHelper.new
  end

  def init
    @updated_at = self[:updated_at]
    @created_at = self[:created_at]
    @author_id = self[:author_id]
    @text = self[:text]
    @title = self[:title]
    @edit_count = self[:edit_count]
    @shared = self[:shared]
    @fav = self[:fav]
    @html_text = self[:html_text]
    @id = self[:id]
  end

  before_save do
    @text = helper.sanitize @text.strip
    @title = set_title_from_text
    self.hashtags= set_hashtags_from_text
    if self.new_record?
      @edit_count = self[:edit_count]
    else
      @edit_count = self[:edit_count] + 1
    end
    @shared = set_shared_state
    @fav = set_fav_state
    @html_text = set_html_text @text
    self[:author_id] = @author_id
    self[:text] = self.text
    self[:title] = self.title
    self[:edit_count] = self.edit_count
    self[:shared] = self.shared
    self[:fav] = self.fav
    self[:html_text] = self.html_text
    @updated_at = self[:updated_at]
    @created_at = self[:created_at]
  end

  def set_title_from_text
    new_title = /@[tT][iI][tT][lL][eE]\{(.+)\}/.match(@text)
    new_title.nil? ? new_title = '' : new_title = helper.truncate(new_title[1].strip,
      :length => 60, :separator => ' ')
    # also adds links to hashtag search
    helper.truncate(text_with_linked_hashtags(new_title),
      :length => 254, :separator => ' <a')
  end

  def set_hashtags_from_text
    new_hashtag_names = []
    new_hashtags = []
    @text.scan(/#(\w+)/) { |tag| new_hashtag_names.push(tag[0].downcase) }
    unless new_hashtag_names.blank?
      existing_hashtags = Hashtag.all(:conditions => {:name => new_hashtag_names})
      existing_hashtags.each do |tag|
        tag.with_lock do
          tag.increment! :hits
        end
        new_hashtag_names.delete tag.name
        new_hashtags.push tag
      end
    end
    #now we create the new ones
    new_hashtag_names.each do |new_name|
      new_hashtags.push Hashtag.create(:name => new_name)
    end
    new_hashtags
  end

  def set_html_text(text)
    new_html_text = text.clone
    # Remove note tags
    new_html_text.gsub!(/@[tT][iI][tT][lL][eE]\{.+\}/,'')
    new_html_text.gsub!(/@public@/i,'')
    new_html_text.gsub!(/@fav@/i,'')
    new_html_text = helper.simple_format(new_html_text.strip)
    new_html_text.gsub!(/[\r\n]/,'')
    # Adds bold tags
    new_html_text.gsub!(/\*[[:print:]&&[^\*]]*\*/) do |b|
      bold_text = b[1...-1]
      bold_text == '' ? '**' : "<b>"+bold_text+"</b>"
    end
    # Adds italic tags
    new_html_text.gsub!(/_[[:print:]&&[^_]]+_/) do |b|
      "<i>"+b[1...-1]+"</i>"
    end
    text_with_linked_hashtags new_html_text
  end

  def set_shared_state
    shared_state = /@public@/i.match(@text)
    !!shared_state
  end

  def set_fav_state
    fav_state = /@fav@/i.match(@text)
    !!fav_state
  end

  def text_with_linked_hashtags(text_to_link)
    text_to_link.gsub(/#\w+/) do |h|
      "<a class='hashtag' href='/hashtags/"+h[1..-1]+"'>"+h+"</a>"
    end
  end


end