# frozen_string_literal: true

# name: chinese-search
# about: -
# version: 0.1
# authors: chenyxuan
# url: https://github.com/chenyxuan


register_asset 'stylesheets/common/chinese-search.scss'
register_asset 'stylesheets/desktop/chinese-search.scss', :desktop
register_asset 'stylesheets/mobile/chinese-search.scss', :mobile

enabled_site_setting :chinese_search_enabled

PLUGIN_NAME ||= 'ChineseSearch'

load File.expand_path('lib/chinese-search/engine.rb', __dir__)

after_initialize do
  # https://github.com/discourse/discourse/blob/master/lib/plugin/instance.rb
  class ::Search
    module OverridingPrepareData
      def prepare_data(search_data, purpose = :query)
        purpose ||= :query

        data = search_data.dup
        data.force_encoding("UTF-8")
        if purpose != :topic
          # TODO cppjieba_rb is designed for chinese, we need something else for Japanese
          # Korean appears to be safe cause words are already space seperated
          # For Japanese we should investigate using kakasi
          if ['zh_TW', 'zh_CN', 'ja'].include?(SiteSetting.default_locale) || SiteSetting.search_tokenize_chinese_japanese_korean
            require 'cppjieba_rb' unless defined? CppjiebaRb
            mode = (purpose == :query ? :query : :mix)
            
            jieba_data = CppjiebaRb.segment(search_data, mode: mode)
            sliced_data = []
            jieba_data.each do |seg|
              if (seg =~ /\p{Han}/) == nil
                sliced_data.push(seg)
              else
                sliced_data.concat(seg.split(''))
              end
            end
            data = sliced_data
            
            # TODO: we still want to tokenize here but the current stopword list is too wide
            # in cppjieba leading to words such as volume to be skipped. PG already has an English
            # stopword list so use that vs relying on cppjieba
            if ts_config != 'english'
              data = CppjiebaRb.filter_stop_word(data)
            else
              data = data.filter { |s| s.present? }
            end

            data = data.join(' ')

          else
            data.squish!
          end

          if SiteSetting.search_ignore_accents
            data = strip_diacritics(data)
          end
        end

        data.gsub!(/\S+/) do |str|
          if str =~ /^["]?((https?:\/\/)[\S]+)["]?$/
            begin
              uri = URI.parse(Regexp.last_match[1])
              uri.query = nil
              str = uri.to_s
            rescue URI::Error
              # don't fail if uri does not parse
            end
          end

          str
        end

        data
      end
    end
    
    module OverridingExecute
      def execute(readonly_mode: Discourse.readonly_mode?)
        if SiteSetting.log_search_queries? && @opts[:search_type].present? && !readonly_mode
          status, search_log_id = SearchLog.log(
            term: @term,
            search_type: @opts[:search_type],
            ip_address: @opts[:ip_address],
            user_id: @opts[:user_id]
          )
          @results.search_log_id = search_log_id unless status == :error
        end

        # If the term is a number or url to a topic, just include that topic
        if @opts[:search_for_id] && ['topic', 'private_messages', 'all_topics'].include?(@results.type_filter)
          if @term =~ /^\d+$/
            single_topic(@term.to_i)
          else
            begin
              if route = Discourse.route_for(@term)
                if route[:controller] == "topics" && route[:action] == "show"
                  topic_id = (route[:id] || route[:topic_id]).to_i
                  single_topic(topic_id) if topic_id > 0
                end
              end
            rescue ActionController::RoutingError
            end
          end
        end

        find_grouped_results if @results.posts.blank?

        if preloaded_topic_custom_fields.present? && @results.posts.present?
          topics = @results.posts.map(&:topic)
          Topic.preload_custom_fields(topics, preloaded_topic_custom_fields)
        end

        @results
      end
    end

    singleton_class.prepend OverridingPrepareData
    prepend OverridingExecute

  end

end
