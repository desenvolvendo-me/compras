jQuery(document).ready(function($){
  $("input.modal").on('change', function (event, record) {
    if (record) {
      $(this).parent().find(".modal_info a").attr("href", record.modal_info_url);
    }
  });

  // Code duplication, needs refactoring to merge with the code above this
  $(".another_modal_info").on('change', function(event, record){
    $(this).parent().next('a').attr('href', record.modal_info_url);
  });

  $(".modal_info a").on('click', function(event){
    event.preventDefault();
    var url = this.href;
    $.getScript(url);
  });

  $('.record_modal_link').on('click', function(event){
    event.preventDefault();
    var url = this.href + '.js';
    $.getScript(url);
  });
});
