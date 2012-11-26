//= require unico-assets
//= require bignumber
//= require compras/simple_form.toogle_required_input
//= require compras/simple_form.numeric_input
//= require compras/currency_manipulation

$(".clear").live('click', function() {
  $(this).closest(".modal-finder").find("input.modal").val("");
})

$(".records").on("click", '.modal-finder-remove', function () {
  $(this).closest("tr").remove();
  return false;
});

$(".modal-finder .modal input.modal").live("change", function(event, record) {
  var id = $(this).attr("id");
  var template = "#" + id + "_template";
  var defaults = {
    index: _.uniqueId('fresh-'),
    uuid: _.uniqueId('fresh-')
  }

  var options = $.extend({}, defaults, record);

  if ($("#" + id + "_record_" + record.id + '_id').length == 0 ) {
    $("." + id + "_records").append($(template).mustache(options));
  }

  $(this).val('');
});
