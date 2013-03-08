$(function() {
  $("form").delegate("input.date", "change", function() {
    var chosenDate = $(this).val();

    $(this).closest("div .input").removeClass("field_with_errors");
    $(this).closest("div .input").find(".date-error").remove();

    if (chosenDate && !moment(chosenDate, ["DD/MM/YYYY"]).isValid()) {
      $(this).closest("div .input").addClass("field_with_errors");
      $(this).closest("div .input").append("<p class='error date-error'>data inválida</p>");
    }

    enableDisableSubmit();
  });

  function enableDisableSubmit() {
    var fieldsWithError = $("p.date-error");

    if (fieldsWithError.length > 0) {
      $("form").find("input:submit").attr("data-disabled", "Há campos inválidos no formulário");
    } else {
      $("form").find("input:submit").removeAttr("data-disabled");
    }
  }
});
