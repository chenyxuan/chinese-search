class ChineseSearchConstraint
  def matches?(request)
    SiteSetting.chinese_search_enabled
  end
end
