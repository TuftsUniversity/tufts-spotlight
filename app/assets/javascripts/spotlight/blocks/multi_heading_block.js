SirTrevor.Blocks.MultiHeading = (function() {

  return SirTrevor.Blocks.Heading.extend({
    type: "multi_heading",
    heading_key: "heading-type",

    formId: function(id) {
      return this.blockID + "_" + id;
    },

    title: function() { return "New Heading"; },

    template: [
      '<div class="field">',
        '<input data-key="<%= heading_key %>" type="radio" name="<%=heading_key %>" id="<%= formId(heading_key + "-h2") %>" value="h2" checked="true">',
        '<label for="<%= formId(heading_key + "-h2") %>">Heading</label>',
        '<input data-key="<%= heading_key %>" type="radio" name="<%= heading_key %>" id="<%= formId(heading_key + "-h3") %>" value="h3">',
        '<label for="<%= formId(heading_key + "-h3") %>">Subheading</label>',
        '<h2 class="st-required st-text-block st-text-block--heading" contenteditable="true"></h2>',
      '</div>',
    ].join("\n"),

    editorHTML: function() {
      return _.template(this.template, this)(this);
    }
  });
})();

