function mustache (mustache, binds) {
  var name, mustache = mustache.replace(/<\\\/script>/g, "</script>");

  for (name in binds) {
    mustache = mustache.replace(new RegExp('{{' + name + '}}', 'g'), binds[name]);
  }

  return mustache;
}

jQuery.fn.mustache = function (binds) {
  return mustache(this.html(), binds);
};
