//= require unico-assets
//= require bignumber
//= require compras/simple_form.toogle_required_input
//= require compras/simple_form.numeric_input
//= require compras/currency_manipulation
//= require compras/modal_info_link_disabler
//= require compras/session_timeout
//= require jquery.ui.autocomplete
//= require simple_form.auto_complete_input.js

$(".clear").live('click', function() {
  $(this).closest(".modal-finder").find("input.modal").val("");
});

$(".modal-finder-remove").live("click", function () {
  if (!$(this).data('disabled')) {
    $(this).closest("tr").remove();
  }
  return false;
});

$(".modal-finder .modal input.modal").live("change", function(event, record) {
  var id = $(this).attr("id");
  var template = "#" + id + "_template";
  var defaults = {
    index: _.uniqueId('fresh-'),
    uuid: _.uniqueId('fresh-')
  };

  var options = $.extend({}, defaults, record);

  if ($("#" + id + "_record_" + record.id + '_id').length == 0 ) {
    $("." + id + "_records").append($(template).mustache(options));
  }

  $(this).val('');
});
