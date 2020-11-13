module ChineseSearch
  class ChineseSearchController < ::ApplicationController
    requires_plugin ChineseSearch

    before_action :ensure_logged_in

    def index
    end
  end
end
