$(document).on("focus", "input[data-decimal]", function () {
  var input = $(this);

  input.priceFormat({
    prefix: false,
    thousandsSeparator: ".",
    centsSeparator: ",",
    centsLimit: input.data("precision")
  });
});
