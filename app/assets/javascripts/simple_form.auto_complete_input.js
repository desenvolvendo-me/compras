(function ($) {
  $("input[data-auto-complete]").live('focus', function() {
    var input = $(this),
        hiddenInput = $('#' + input.data("hidden-field-id")),
        valueAttribute = input.data("hidden-field-value-attribute"),
        maxResults = input.data("max-results");

    input.autocomplete({
      minLength: 3,
      delay: 500,

      source: function(params, response) {
        params.limit = maxResults;
        $.getJSON(input.data("source"), params, function(data) { response(data) });
      },

      select: function(event, ui) {
        input.val(ui.item.label);
        hiddenInput.val(ui.item[valueAttribute]);
        input.trigger('change', ui.item);
      },

      response: function(event, ui) {
        $(this).removeClass("loading");
      }
    });

    input.keyup(function(event) {
      if ($(this).val() === "") {
        $(this).removeClass("loading");
      } else {
        var invalidKeys = [37, 39, 38, 40, 13, 27, 9, 16, 17, 18, 91];
        if (!_.contains(invalidKeys, event.which)){
          $(this).addClass("loading");
        }
      }
    });

    input.change(function (event, object) {
      $(this).removeClass("loading");
      if (object === null && _.isEmpty(input.val())) {
        hiddenInput.val("");
      }
    });
  });
})(jQuery);
