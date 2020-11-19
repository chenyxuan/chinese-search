# frozen_string_literal: true

# name: chinese-search
# about: -
# version: 0.2
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
            mode = (purpose == :query ? :mix : :full)
            data = CppjiebaRb.segment(search_data, mode: mode)

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
    
    singleton_class.prepend OverridingPrepareData

  end

end
