require 'rails_helper'
require 'utils/host'

RSpec.describe Utils::Host do
  describe '#localhost' do
    # Backup Rails configuration
    before do
      @old_params = Rails.application.default_url_options
    end

    # Restore Rails configuration
    after do
      Rails.application.default_url_options = @old_params # rubocop:disable RSpec/InstanceVariable
    end

    it 'returns local host and port' do
      Rails.application.default_url_options = { host: 'http://localhost', port: 3000 }

      expect(described_class.localhost).to eq 'localhost:3000'
    end

    context 'when a common port is declared' do
      it 'returns host only' do
        Rails.application.default_url_options = { host: 'http://example.com', port: 80 }

        expect(described_class.localhost).to eq 'example.com'
      end
    end

    context 'when no port is declared' do
      it 'returns host only' do
        Rails.application.default_url_options = { host: 'http://example.com' }

        expect(described_class.localhost).to eq 'example.com'
      end
    end
  end

  describe '#local_url?' do
    context 'when URL points to the local server' do
      it 'returns true' do
        expect(described_class.local_url?('http://localhost/something/else')).to be true
      end
    end

    context 'when URL does not point to the local server' do
      it 'returns false' do
        # during tests, localhost has no port
        expect(described_class.local_url?('http://localhost:3000/something/else')).to be false
      end
    end
  end

  describe '#local_route' do
    context 'when URL is a local URL' do
      it 'returns a Rails route' do
        url = 'http://localhost/'
        expect(described_class.local_route(url)).to be_a Hash
      end
    end

    context 'when URL is not a local url' do
      it 'returns nil' do
        url = 'https://google.com'
        expect(described_class.local_route(url)).to be_nil
      end
    end
  end
end
