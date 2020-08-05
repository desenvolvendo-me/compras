(function ($) {
  $(document).on( 'focus', 'input[data-mask]', function () {
    var input = $(this);

    input.mask(input.attr("data-mask")).trigger('focus.mask');
  });
})(jQuery);
