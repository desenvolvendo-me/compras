/*
 * Disabled element
 *
 * This code serves to:
 *   - stop the click event in a link or input;
 *   - show a tip with the cause when I put the mouse over the html element.
 *
 *  Example:
 *
 *   <a data-disabled="Anything">Link</a>
 *
 * If I try to click on the link above will return nothing and
 * if I put the mouse over the link will show a tip with "Anything" as content.
 *
 * With rails we can do something like this:
 *
 *   <%= link_to "Show", :data => { :disabled => (resource.cant_show? ? "Can not show" : nil) } %>
 *
 * or with decorator:
 *
 *   <%= link_to "Show", :data => { :disabled => resource.decorator.cant_not_show_message } %>
 *
 */

$(document).on("click", "a[data-disabled], input[data-disabled], button[data-disabled]", function(event) {
  event.stopImmediatePropagation();
  return false;
});

$(document).tooltip({
  items: "a[data-disabled], input[data-disabled], button[data-disabled]",
  content: function() {
    return $(this).data("disabled");
  },
  position: { my: "center top+15" }
});
