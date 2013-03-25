function addRecordToGrid(record, input) {
  if (!canInsertRecord(record, input)) {
    alert("Registro já inserido...");
    $(input).val('');
    return false;
  }

  var id = $(input).attr("id");
  var template = "#" + id + "_template";
  var defaults = {
    index: _.uniqueId('fresh-'),
    uuid: _.uniqueId('fresh-')
  };

  var options = $.extend({}, defaults, record);

  if ($("#" + id + "_record_" + record.id + '_id').length == 0 ) {
    $("." + id + "_records").append($(template).mustache(options));
  }
}

function removeFromGrid(input) {
  if (!$(input).data('disabled')) {
    $(input).closest("tr").remove();
  }

  return false;
}

function canInsertRecord(record, input) {
  var available = true,
      gridRows = $("." + $(input).attr("id") + "_records tr");

  gridRows.each(function(index, element) {
    var recordId = record.id.toString();
    var hiddenId = $(element).children("td").find(".autocomplete-form-hidden-id").val();

    if (recordId == hiddenId) {
      available = false;
      return false;
    };
  });

  return available;
}

$(".autocomplete-form-remove").live("click", function(event) {
  event.preventDefault();
  removeFromGrid(this);
});

$(".autocomplete-form-input").live("change", function(event, record) {
  if (record) {
    addRecordToGrid(record, this);
    $(this).val('');
  }
});
