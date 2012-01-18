(function ($) {
  $('input[data-mask]').live('focus', function () {
    $(this).mask($(this).attr("data-mask"));
  });
})(jQuery);
