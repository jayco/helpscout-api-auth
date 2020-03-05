# frozen_string_literal: true

RSpec.describe Helpscout::Api::Auth::Token do
  it 'raises an error if missing :client_id and :client_secret' do
    expect do
      Helpscout::Api::Auth::Token.new
    end.to raise_error(ArgumentError)
  end

  it 'raises an error if request fails' do
    expect do
      stub_request(:post, 'https://api.helpscout.net/v2/oauth2/token').to_raise(StandardError)
      token = Helpscout::Api::Auth::Token.new(client_id: 'some id', client_secret: 'keep it secret')
    end.to raise_error(StandardError)
  end

  it 'returns a token on success' do
    body = URI.encode_www_form(client_id: 'some id', client_secret: 'keep it secret', grant_type: 'client_credentials')

    stub_request(:post, 'https://api.helpscout.net/v2/oauth2/token')
      .with(body: body, headers: { 'Content-Type': 'application/x-www-form-urlencoded' })
      .to_return(body: { expires_in: '1', access_token: 'some_token' }.to_json)

    token = Helpscout::Api::Auth::Token.new(client_id: 'some id', client_secret: 'keep it secret')
    expect(token.access_token).to eql('some_token')
  end

  context 'refresh' do
    it 'refresh a token when expired' do
      body = URI.encode_www_form(client_id: 'some id', client_secret: 'keep it secret', grant_type: 'client_credentials')

      stub_request(:post, 'https://api.helpscout.net/v2/oauth2/token')
        .with(body: body, headers: { 'Content-Type': 'application/x-www-form-urlencoded' })
        .to_return(body: { expires_in: '1', access_token: 'some_token' }.to_json)

      token = Helpscout::Api::Auth::Token.new(client_id: 'some id', client_secret: 'keep it secret')

      expect(token.access_token).to eql('some_token')
      sleep 1

      stub_request(:post, 'https://api.helpscout.net/v2/oauth2/token')
        .with(body: body, headers: { 'Content-Type': 'application/x-www-form-urlencoded' })
        .to_return(body: { expires_in: '1', access_token: 'some_other_token' }.to_json)

      token.refresh
      expect(token.access_token).to eql('some_other_token')
    end

    it 'do not refresh a token when valid' do
      body = URI.encode_www_form(client_id: 'some id', client_secret: 'keep it secret', grant_type: 'client_credentials')

      stub_request(:post, 'https://api.helpscout.net/v2/oauth2/token')
        .with(body: body, headers: { 'Content-Type': 'application/x-www-form-urlencoded' })
        .to_return(body: { expires_in: '10', access_token: 'some_token' }.to_json)

      token = Helpscout::Api::Auth::Token.new(client_id: 'some id', client_secret: 'keep it secret')
      expect(token.access_token).to eql('some_token')

      stub_request(:post, 'https://api.helpscout.net/v2/oauth2/token')
        .with(body: body, headers: { 'Content-Type': 'application/x-www-form-urlencoded' })
        .to_return(body: { expires_in: '1', access_token: 'some_other_token' }.to_json)

      token.refresh
      expect(token.access_token).to eql('some_token')
    end
  end

  context 'to_s' do
    it 'return a formated Bearer token string' do
      body = URI.encode_www_form(client_id: 'some id', client_secret: 'keep it secret', grant_type: 'client_credentials')

      stub_request(:post, 'https://api.helpscout.net/v2/oauth2/token')
        .with(body: body, headers: { 'Content-Type': 'application/x-www-form-urlencoded' })
        .to_return(body: { expires_in: '1', access_token: 'some_token' }.to_json)

      token = Helpscout::Api::Auth::Token.new(client_id: 'some id', client_secret: 'keep it secret')
      expect(token.to_s).to eql('Bearer some_token')
    end
  end
end
