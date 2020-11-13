require_dependency "chinese_search_constraint"

ChineseSearch::Engine.routes.draw do
  get "/" => "chinese_search#index", constraints: ChineseSearchConstraint.new
  get "/actions" => "actions#index", constraints: ChineseSearchConstraint.new
  get "/actions/:id" => "actions#show", constraints: ChineseSearchConstraint.new
end
