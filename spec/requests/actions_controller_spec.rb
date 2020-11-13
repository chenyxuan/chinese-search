require 'rails_helper'

describe chinese-search::ActionsController do
  before do
    Jobs.run_immediately!
  end

  it 'can list' do
    sign_in(Fabricate(:user))
    get "/chinese-search/list.json"
    expect(response.status).to eq(200)
  end
end
