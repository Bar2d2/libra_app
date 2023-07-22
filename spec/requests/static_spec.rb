require 'rails_helper'

RSpec.describe "Statics", type: :request do
  describe 'routing' do
    it "should get index" do
      get '/'
      expect(response).to have_http_status(200)
    end
  end
end
