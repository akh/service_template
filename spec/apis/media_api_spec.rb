require 'spec_helper'

RSpec.describe MediaAPI do
  include Rack::Test::Methods

  def app
    MediaAPI
  end

  let(:attrs) { attributes_for(:media) }

  describe 'GET' do
    it 'get media list successfully' do
      expected_media_ids = (1..10).map { (create :media).id.to_s }.sort

      get "/medias".with_version
      expect(resp.status).to eq 200
      actual_media_ids = resp_body['data'].map { |media| media['id'] }.sort
      expect(actual_media_ids).to eq(expected_media_ids)
    end
  end
end