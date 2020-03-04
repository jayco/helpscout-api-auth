# frozen_string_literal: true

RSpec.describe Helpscout::Api::Auth::Token do
  it 'creates a token class' do
    expect(Helpscout::Api::Auth::Token.new).not_to be nil
  end
end
