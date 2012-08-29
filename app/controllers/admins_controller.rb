class AdminsController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @users = User.all :order => :username
    @sessions = SessionCredential.all(:order => :created_at).reverse
    @session_notes_count = Hash[@sessions.collect{
      |s| [s.session_id, Note.find_all_by_author_id(s.author_id).count] }]
    confirmed_users = User.count :confirmed_at
    @users_chart = pie_chart ["Confirmed", confirmed_users],
      ["Unconfirmed", @users.size - confirmed_users], ["Session", @sessions.size]
    @notes_count = Note.count
    @hashtags = Hashtag.all(:order => :hits).reverse
    @registers_chart = timeline_chart User.group("DATE(created_at)").count, 'registers'
    @logins_chart = timeline_chart User.group("DATE(last_sign_in_at)").count, 'logins'
    @logins_average = User.average :sign_in_count
  end

  def show
    author_id = params[:id]
    if author_id == 'all'
      @notes = Note.all(:order => :updated_at).reverse
    else
      @notes = Note.find_all_by_author_id(author_id, :order => :updated_at).reverse
    end
  end

  private

  def timeline_chart(data_by_day, data_name)
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('date')
    data_table.new_column('number', data_name)
    data_by_day.each do |day|
      data_table.add_row([ Date.parse(day[0]), day[1]])
    end
    @chart = GoogleVisualr::Interactive::AnnotatedTimeLine.new(data_table)
  end

  def pie_chart(*data)
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Users')
    data_table.new_column('number', 'Total')
    data_table.add_rows(data.size)
    cell_index = 0
    data.each do |cell|
      data_table.set_cell(cell_index, 0, cell[0])
      data_table.set_cell(cell_index, 1, cell[1])
      cell_index += 1
    end
    @chart = GoogleVisualr::Interactive::PieChart.new(data_table, :is3D => true)
  end

  def authenticate_admin!
    redirect_to new_user_session_path unless user_signed_in? && current_user.admin
  end

end