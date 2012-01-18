jQuery(document).ready(function($){
  $(".modal").change(function (event, data) {
    if (data){
      var record = data.record,
          link = '#' + $(this).attr('id') + '_info_link';
      $(link).data("modal-url", record.data("modal-info-url"));
    }
  });

  $(".modal_info").click(function(event){
    event.preventDefault();
    var url = $(this).data("modal-url");
    if (url != ''){
      $.getScript(url);
    }
  });

  $('.record_modal_link').click(function(event){
    event.preventDefault();
    var url = this.href + '.js';
    $.getScript(url);
  });
});
