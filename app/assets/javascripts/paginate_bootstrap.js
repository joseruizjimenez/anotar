$(document).ready(function(){

  //how much items per page to show
  var show_per_page = 5;
  //getting the amount of elements inside content div
  var number_of_items = $('#content').children().size();
  //calculate the number of pages we are going to have
  var number_of_pages = Math.ceil(number_of_items/show_per_page);

  //set the value of our hidden input fields
  $('#current_page').val(0);
  $('#show_per_page').val(show_per_page);

  var navigation_html = '<ul>';

  navigation_html += '<li class="previous_link">';
  navigation_html += '<a href="javascript:previous();">&larr; Previous</a>';
  navigation_html += '</li>';
  var current_link = 0;
  while(number_of_pages > current_link){
    navigation_html += '<li class="page_link" id="id' + current_link +'">';
    navigation_html += '<a href="javascript:go_to_page(' + current_link +')" longdesc="' + current_link +'">'+ (current_link + 1) +'</a>';
    current_link++;
    navigation_html += '</li>';
  }
  navigation_html += '<li>';
  navigation_html += '<a class="next_link" href="javascript:next();">Next &rarr;</a>';
  navigation_html += '</li>';
  navigation_html += '</ul>';

  $('#page_navigation').html(navigation_html);

  //add active class to the first page link
  $('#page_navigation .page_link:first').addClass('active');

  //hide all the elements inside content div
  $('#content').children().css('display', 'none');

  //and show the first n (show_per_page) elements
  $('#content').children().slice(0, show_per_page).css('display', 'block');

});

function previous(){

  new_page = parseInt($('#current_page').val()) - 1;
  //if there is an item before the current active link run the function
  if($('.active').prev('.page_link').length==true){
    go_to_page(new_page);
  }

}

function next(){
  new_page = parseInt($('#current_page').val()) + 1;
  //if there is an item after the current active link run the function
  if($('.active').next('.page_link').length==true){
    go_to_page(new_page);
  }

}

function go_to_page(page_num){
  //get the number of items shown per page
  var show_per_page = parseInt($('#show_per_page').val());

  //get the element number where to start the slice from
  start_from = page_num * show_per_page;

  //get the element number where to end the slice
  end_on = start_from + show_per_page;

  activate_id = page_num;
  var get_box = document.getElementById("id"+page_num);
  //hide all children elements of content div, get specific items and show them
  $('#content').children().css('display', 'none').slice(start_from, end_on).css('display', 'block');

  /*get the page link that has longdesc attribute of the current page and add active class to it
  and remove that class from previously active page link*/
  $("#page_navigation").find('li.active').removeClass("active");
  $(get_box).addClass("active");


  //update the current page input field
  $('#current_page').val(page_num);
}