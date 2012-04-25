(function ($) {
  /**
   * Nested forms v0.0.2
   *
   * Example:
   *
   *   $("selector-of-template").nestedForm({
   *     add: "selector-of-add-button",
   *     remove: "selector-of-remove-button",
   *     target: "selector-of-target",
   *     uuid: "uuid_name"
   *   });
   */
  $.fn.nestedForm = function (options) {
    var template = $(this);
    var defaults = {
      add: '.add',
      remove: '.remove',
      fieldToRemove: 'fieldset',
      hiddenDestroyInput: 'input.hidden.destroy',
      target: '#targe',
      uuid: 'uuid',
      right: false,
      appendItem: true
    };
    var options = $.extend({}, defaults, options);

    var displayFirstLabels = function() {
      $(options.target + ' .nested label').hide();
      $(options.target + ' .nested label').closest('.nested').find('.nested-remove').css('padding-top', '4px');

      $(options.target + " .nested:visible:first label").show();
      $(options.target + " .nested:visible:first .nested-remove").css('padding-top', '30px');
    }

    $('body').delegate(options.add, 'click', function () {
      var binds = {};
      binds[options.uuid] = _.uniqueId('fresh-');

      if (options.appendItem) {
        $(options.target).append(template.mustache(binds)).trigger('append.mustache');
      } else {
        $(options.target).prepend(template.mustache(binds)).trigger('append.mustache');
      }

      if (options.right) {
        displayFirstLabels();
      }
    });

    $(options.target).delegate(options.remove, 'click', function () {
      $(this).closest(options.fieldToRemove).hide().find(options.hiddenDestroyInput).val('true');

      if (options.right) {
        displayFirstLabels();
      }
    });

    if (options.right) {
      displayFirstLabels();
    }

    // hidding the elements marked for destruction
    $(options.fieldToRemove).each(function() {
      if($(this).find('input.destroy').val() == 'true') {
        $(this).hide();
      }
    });
  };
})(jQuery);
