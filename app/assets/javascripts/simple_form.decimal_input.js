(function ($) {
  $('input[data-decimal]').live('focus', function () {
    $(this).priceFormat({
      prefix: '',
      thousandsSeparator: '',
      centsSeparator: ','
    });
  });
})(jQuery);
