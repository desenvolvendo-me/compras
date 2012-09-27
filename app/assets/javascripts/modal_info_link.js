jQuery(document).ready(function($){
  $("input.modal").live('change', function (event, record) {
    if (record) {
      $(this).parent().find(".modal_info a").attr("href", record.modal_info_url);
    }
  });

  $(".modal_info a").live('click', function(event){
    event.preventDefault();
    var url = this.href;
    $.getScript(url);
  });
});
