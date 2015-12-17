require 'spec_helper'

describe UniSender::Client do

  it 'should get invalid key error' do
    answer = UniSender::Client.new("123abcd123").getLists
    expect(answer['error']).to be_truthy
    expect(answer['code']).to eq 'invalid_api_key'
  end

  specify { expect(test_client.get_lists).to eq test_client.getLists }

end
