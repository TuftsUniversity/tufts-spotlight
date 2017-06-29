SirTrevor.Blocks.Subheading = (function() {

  return SirTrevor.Block.extend({
    type: "subheading",

    title: function() { return "hi!" },

    icon_name: "tweet",

    formable: true,

    editorHTML: function() {
      return _.template(this.template, this)(this);
    },

    template: '<input type="text" name="title" />'

  });
})();

