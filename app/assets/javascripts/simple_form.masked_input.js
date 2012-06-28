(function ($) {
  $('input[data-mask]').live('focus', function () {
    var input = $(this);

    input.mask(input.attr("data-mask")).trigger('focus.mask');
  });
})(jQuery);
