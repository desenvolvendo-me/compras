jQuery(document).ready(function($){
  $(".modal").live('change', function (event, data) {
    if (data){
      var record = data.record,
          link = '#' + $(this).attr('id') + '_info_link';
      $(link).attr("href", record.data("modal-info-url"));
    }
  });

  // Code duplication, needs refactoring to merge with the code above this
  $(".another_modal_info").live('change', function(event, data){
    var record = data.record;
    $(this).parent().next('a').attr('href', record.data('modal-info-url'));
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
