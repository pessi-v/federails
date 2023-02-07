require 'rails_helper'

RSpec.describe Following, type: :model do
  let(:actor) { FactoryBot.create(:user).actor }
  let(:other_actor) { FactoryBot.create(:user).actor }
  let(:following) { described_class.create actor: actor, target_actor: other_actor }

  it 'fails to create the same following twice' do
    following
    second = described_class.create actor: actor, target_actor: other_actor
    expect(second).not_to be_valid
  end
end
