SirTrevor.Blocks.MultiHeading = (function() {

  // Some of this stuff is in formable mixin, but I can't get it to mix in.
  //   formable: true, doesn't seem to work.
  return SirTrevor.Blocks.Heading.extend({
    type: "multi_heading",
    heading_key: "heading-type",

    isH2: function() {
      // Default to h2, if things get funky.
      return this.blockStorage.data[this.heading_key] !== "h3"  ? 'checked="true"' : "";
    },
    isH3: function() {
      return this.blockStorage.data[this.heading_key] === "h3"  ? 'checked="true"' : "";
    },

    formId: function(id) {
      return this.blockID + "_" + id;
    },

    title: function() { return "New Heading"; },

    template: [
      '<div class="field heading-type-editor">',
        '<input data-key="<%= heading_key %>" type="radio" name="<%= heading_key %>" id="<%= formId(heading_key + "-h2") %>" value="h2" <%= isH2() %>>',
        '<label for="<%= formId(heading_key + "-h2") %>"><h2>Heading</h2></label>',
        '<input data-key="<%= heading_key %>" type="radio" name="<%= heading_key %>" id="<%= formId(heading_key + "-h3") %>" value="h3" <%= isH3() %>>',
        '<label for="<%= formId(heading_key + "-h3") %>"><h3>Subheading</h3></label>',
        '<h2 class="st-required st-text-block st-text-block--heading" contenteditable="true"></h2>',
      '</div>',
    ].join("\n"),

    editorHTML: function() {
      return _.template(this.template, this)(this);
    }
  });
})();

