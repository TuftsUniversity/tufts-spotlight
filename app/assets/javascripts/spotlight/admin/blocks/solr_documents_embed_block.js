//= require spotlight/admin/blocks/solr_documents_block

SirTrevor.Blocks.SolrDocumentsEmbed = (function(){

  return SirTrevor.Blocks.SolrDocuments.extend({
    type: "solr_documents_embed",

    icon_name: "item_embed",

    item_options: function() { return "" },

    caption_option_values: function() {
      var fields = $('[data-blacklight-configuration-index-fields]').data('blacklight-configuration-index-fields');

      return $.map(fields, function(field) {
        return $('<option />').val(field.key).text(field.label)[0].outerHTML;
      }).join("\n");
    },

    item_options: function() { return this.caption_options(); },

    caption_options: function() { return [
      '<div class="field-select primary-caption" data-behavior="item-caption-admin">',
        '<input name="<%= show_primary_field_key %>" type="hidden" value="false" />',
        '<input data-input-select-target="#<%= formId(primary_field_key) %>" name="<%= show_primary_field_key %>" id="<%= formId(show_primary_field_key) %>" type="checkbox" value="true" />',
        '<label for="<%= formId(show_primary_field_key) %>"><%= i18n.t("blocks:solr_documents:caption:primary") %></label>',
        '<select data-input-select-target="#<%= formId(show_primary_field_key) %>" name="<%= primary_field_key %>" id="<%= formId(primary_field_key) %>">',
          '<option value=""><%= i18n.t("blocks:solr_documents:caption:placeholder") %></option>',
          '<%= caption_option_values() %>',
        '</select>',
      '</div>',
      '<div class="field-select secondary-caption" data-behavior="item-caption-admin">',
        '<input name="<%= show_secondary_field_key %>" type="hidden" value="false" />',
        '<input data-input-select-target="#<%= formId(secondary_field_key) %>" name="<%= show_secondary_field_key %>" id="<%= formId(show_secondary_field_key) %>" type="checkbox" value="true" />',
        '<label for="<%= formId(show_secondary_field_key) %>"><%= i18n.t("blocks:solr_documents:caption:secondary") %></label>',
        '<select data-input-select-target="#<%= formId(show_secondary_field_key) %>" name="<%= secondary_field_key %>" id="<%= formId(secondary_field_key) %>">',
        '<option value=""><%= i18n.t("blocks:solr_documents:caption:placeholder") %></option>',
          '<%= caption_option_values() %>',
        '</select>',
      '</div>',
    ].join("\n") },

    afterPreviewLoad: function(options) {
      $(this.inner).find('picture[data-openseadragon]').openseadragon();
    }
  });

})();
