require 'spec_helper'

RSpec.describe Media, :type => :model do
  it { is_expected.to be_stored_in :medias }
  it { is_expected.to be_timestamped_document }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:introduction) }

  it { is_expected.to validate_presence_of(:account) }
  it { is_expected.to validate_uniqueness_of(:account).case_insensitive }

  it { is_expected.to have_index_for(account: 1).with_options(unique: true, background: true) }

  it 'should have correct json form' do
    media = create(:media)
    expect(media.as_json).to eq({
                                  "id" => media.id.to_s,
                                  "name" => media.name,
                                  "introduction" => media.introduction,
                                  "account" => media.account,
                                  "created_at" => media.created_at,
                                  "updated_at" => media.updated_at
                                })
  end
end