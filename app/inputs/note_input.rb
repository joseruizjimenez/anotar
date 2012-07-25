# app/inputs/note_input.rb
class NoteInput < SimpleForm::Inputs::Base
  def input
    note_input_html_options = input_html_options
    note_input_html_options[:class] = "field span12"
    note_input_html_options[:rows] = "6"
    "#{@builder.text_area(attribute_name, note_input_html_options)}".html_safe
  end
end