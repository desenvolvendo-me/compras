function buildAutoCompleteField(input) {
  var hiddenInput     = $('#' + input.data("hidden-field-id")),
      maxResults      = input.data("max-results"),
      resourcePath    = input.data("source"),
      newResourcePath = input.data("new-resource-path"),
      newResourceText = input.data("new-resource-text"),
      preload         = input.data("preload"),
      label           = input.select2("data")['label'];

  var options = {
    minimumInputLength: 2,
    allowClear: true,
    ajax: {
      url: resourcePath,
      dataType: 'json',
      data: function (term, page) {
        var query = {};

        query[input.data("scope")] = term;
        query["maxResults"] = maxResults;
        return query;
      },
      results: function(data, page){
        return { results: data };
      }
    },
    initSelection: function (item, callback) {
      var data = {
        id: hiddenInput.val(),
        label: label || item.val()
      };

      callback(data);
    },
    formatResult: function (item) {
      if (item.summary) {
        return ("<a>" + item.label + "<br><span class='description'>" + item.summary + "</span></a>");
      } else if (item.name) {
        return ("<a>" + item.label + "<br><span class='description'>" + item.name + "</span></a>");
      } else {
        return ("<a>" + item.label + "</a>");
      }
    },
    formatSelection: function (item) {
      hiddenInput.val(item.id);

      return (item.label);
    }
  };
  if (newResourcePath && newResourcePath.length > 0) {
    // Expecting a default text of type string when there's no matches
    var defaultNoMatchesText = $.fn.select2.defaults.formatNoMatches(),
        newResourceLink = "<a href=\"" + newResourcePath + "\" onclick=\"window.open(this.href); return false;\">" + newResourceText + "</a>";

    // Adding the new text with a link to options through jQuery extend
    $.extend(options, {
      formatNoMatches: function (term) {
        // The onclick is necessary for the click to work with select2
        return (defaultNoMatchesText + ". " + newResourceLink);
      }
    });
  }

  if (preload) $.extend(options, { minimumInputLength: false });

  input.select2(options);

  input.on('select2-clearing', function(event) { hiddenInput.val(''); });
}

$( document ).ready(function() {
  (function(){
    var mainDiv = $('input[class*="add"]').closest('div');

    mainDiv.on('nestedForm:afterAdd', function(){
      fieldset = mainDiv.find("fieldset:last");
      selects = fieldset.find("input[data-select_2=true]")

      $.each(selects, function(){
        buildAutoCompleteField($(this));
      });
    });
  })();
});

(function ($) {
  $(document).on('focus', 'input[data-auto-complete]', function() {
    var input           = $(this),
        hiddenInput     = $('#' + input.data("hidden-field-id")),
        valueAttribute  = input.data("hidden-field-value-attribute"),
        maxResults      = input.data("max-results"),
        minLength       = input.data("min-length");
        clearAfterAdd   = input.data('clear-input');

    input.autocomplete({
      delay: 500,
      minLength: minLength,

      source: function(params, response) {
        params.limit = maxResults;

        $.getJSON(input.data("source"), params, function(data) {
          response(data);
        });
      },

      select: function(event, ui) {
        input.val(ui.item.label);
        hiddenInput.val(ui.item[valueAttribute]);
        hiddenInput.trigger('change', ui.item);
        $(this).removeClass("loading");

        if (clearAfterAdd) {
          return false;
        }
      },

      response: function(event, ui) {
        $(this).removeClass("loading");
      },

      change: function(event, ui) {
        if (ui.item === null || _.isEmpty(input.val()) ) {
          hiddenInput.val("");
          hiddenInput.trigger('change', ui.item);
        }
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
  });

  $(function(){
    $("input[data-select_2]").each(function(){ buildAutoCompleteField($(this)); });
  });
})(jQuery);
