jQuery(document).ready(function($){
  $("input.modal").on('change', function (event, record) {
    if (record) {
      $(this).parent().find(".modal_info a").removeAttr("data-disabled");
    } else {
      var message = $(this).parent().find(".modal_info a").attr("data-disabled-message");
      $(this).parent().find(".modal_info a").attr("data-disabled", message);
    }
  });
});
