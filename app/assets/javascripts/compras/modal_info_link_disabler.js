jQuery(document).ready(function($){
  $("input.modal").live('change', function (event, record) {
    if (record) {
      $(this).parent().find(".modal_info a").removeAttr("data-disabled");
    } else {
      var message = $(this).parent().find(".modal_info a").attr("data-disabled-message");
      $(this).parent().find(".modal_info a").attr("data-disabled", message);
    }
  });
});
