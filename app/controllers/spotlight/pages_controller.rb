# frozen_string_literal: true
# Patch line #13 and #23: polymorphic_path no longer accepts string arguments.

require_dependency Spotlight::Engine.root.join('app', 'controllers', 'spotlight', 'pages_controller').to_s

module Spotlight
  class PagesController < Spotlight::ApplicationController
    def create
      @page.attributes = page_params
      @page.last_edited_by = @page.created_by = current_user

      if @page.save
        redirect_to [spotlight, @page.exhibit, page_collection_name.to_sym],
                    notice: t(:'helpers.submit.page.created', model: @page.class.model_name.human.downcase)
      else
        render action: 'new'
      end
    end

    def destroy
      @page.destroy

      redirect_to [spotlight, @page.exhibit, page_collection_name.to_sym],
                  flash: { html_safe: true },
                  notice: undo_notice(:destroyed)
    end
  end
end
