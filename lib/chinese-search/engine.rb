module ChineseSearch
  class Engine < ::Rails::Engine
    engine_name "ChineseSearch".freeze
    isolate_namespace ChineseSearch

    config.after_initialize do
      Discourse::Application.routes.append do
        mount ::ChineseSearch::Engine, at: "/chinese-search"
      end
    end
  end
end
