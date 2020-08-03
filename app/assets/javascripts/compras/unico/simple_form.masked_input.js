(function ($) {
  $(document).on('input[data-mask]', 'focus', function () {
    var input = $(this);

    input.mask(input.attr("data-mask")).trigger('focus.mask');
  });
})(jQuery);
