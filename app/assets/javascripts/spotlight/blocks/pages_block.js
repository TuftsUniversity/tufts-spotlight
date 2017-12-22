//= require spotlight/blocks/resources_block

SirTrevor.Blocks.FeaturedPages = (function(){

  return Spotlight.Block.Resources.extend({
    type: "featured_pages",

    icon_name: "pages",

    autocomplete_url: function() {
      return $(this.inner)
        .closest('form[data-autocomplete-exhibit-pages-path]')
        .data('autocomplete-exhibit-pages-path')
        .replace("%25QUERY", "%QUERY");
    },
    autocomplete_template: function() {
      return '<div class="autocomplete-item{{#unless published}} blacklight-private{{/unless}}">{{log "Look at me"}}{{log thumbnail_image_url}}{{#if thumbnail_image_url}}<div class="document-thumbnail thumbnail"><img src="{{thumbnail_image_url}}" /></div>{{/if}}<span class="autocomplete-title">{{title}}</span><br/><small>&nbsp;&nbsp;{{description}}</small></div>'
    },
    bloodhoundOptions: function() {
      return {
        prefetch: {
          url: this.autocomplete_url(),
          ttl: 0
        }
      };
    },


    /****** Autocomplete Customizations ******/

    sidebarEl: false, // The checkbox for whether sidebar shows or not.
    limit: 5, // How many feature pages can show?
    acInput: false, // The autocomplete input element.
    warning: "This feature row is at the maximum number of items.",
    warningEl: false, // The warning's element.

    /**
     * Builds the warning div, and puts it after the autocomplete.
     */
    makeWarningEl: function() {
      this.warningEl = $("<p>" + this.warning + "</p>");
      this.acInput.after(this.warningEl);
    },

    /**
     * Sets the limit, based on the sidebar.
     */
    setLimit: function() {
      if(this.sidebarEl === false) {
        this.sidebarEl = $('#feature_page_display_sidebar');
      }

      this.limit = $(this.sidebarEl).is(':checked') ? 3 : 5;
    },

    /**
     * Hide or show the autocomplete input.
     *
     * @param {boolean} full
     *   Are we full on panels yet?
     */
    toggleAutocomplete: function(full) {
      if(full) {
        this.acInput.hide();
        this.warningEl.show();
      } else {
        this.acInput.show();
        this.warningEl.hide();
      }
    },

    /**
     * Rechecks if block is full and hides/shows autocomplete.
     * Optionally resets limit too.
     *
     * @param {boolean} resetLimit
     *  Whether or not to reset the limit.
     */
    resetAc: function(resetLimit) {
      if(typeof resetLimit !== undefined) {
        this.setLimit();
      }

      // Counts the items in the block and compares to limit.
      full = ($('li.dd-item', this.inner).length >= this.limit);

      this.toggleAutocomplete(full);
    },

    /**
     * Overwrites Spotlight.Blocks.Resource::onBlockRender.
     * Shows/Hides the autocomplete box based on sidebar and number of panels.
     */
    onBlockRender: function() {
      SpotlightNestable.init($('[data-behavior="nestable"]', this.inner));
      $('[data-input-select-target]', this.inner).selectRelatedInput();

      this.acInput = $('span.twitter-typeahead', this.inner);
      this.makeWarningEl();
      this.resetAc(true);

      // If sidebar selection changes, reset autocomplete.
      this.sidebarEl.on("change", function() {
        this.resetAc(true);
      }.bind(this));
    },

    /**
     * Overwrites Spotlight.Blocks.Resource::afterPanelRender.
     * Shows/Hides the autocomplete box based on sidebar and number of panels.
     */
    afterPanelRender: function(data, panel) {
      // Don't run during page load. Wait until block is fully rendered.
      if(this.acInput) {
        // Code was firing before panel html was actually in the DOM.
        window.setTimeout(this.resetAc.bind(this), 100);
      }
    },

    /**
     * Overwrites Spotlight.Blocks.Resource::afterPanelDelete.
     */
    afterPanelDelete: function() {
      this.resetAc();
    }


  }); // End extend Spotlight.Block.Resources.
})();
