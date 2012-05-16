jQuery(document).ready(function($){
  $(".modal").live('change', function (event, record) {
    if (record){
      var link = '#' + $(this).attr('id') + '_info_link';
      $(link).attr("href", record.modal_info_url);
    }
  });

  // Code duplication, needs refactoring to merge with the code above this
  $(".another_modal_info").live('change', function(event, record){
    $(this).parent().next('a').attr('href', record.modal_info_url);
  });

  $(".modal_info").live('click', function(event){
    event.preventDefault();
    var url = this.href;
    $.getScript(url);
  });

  $('.record_modal_link').live('click', function(event){
    event.preventDefault();
    var url = this.href + '.js';
    $.getScript(url);
  });
});
