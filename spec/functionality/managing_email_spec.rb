#encoding: utf-8
require 'spec_helper'

describe UniSender::Client do

  it 'should create email template' do
    answer = test_client.create_email_message(:sender_name => 'Ваня Петров',
      :sender_email=>'uni.sender.gem@gmail.com',
      :subject=>'You need your stuff',
      :list_id=>available_list_ids.last,
      :lang=>'en', :body=>"Привет дорогой друг!")
    expect(answer).to include('result')
    expect(answer['result']['message_id']).to be_an_kind_of(Numeric)
  end

  it 'should create email template with long body' do
    answer = test_client.create_email_message(:sender_name => 'Ivan Petrov',
      :sender_email => 'uni.sender.gem@gmail.com',
      :subject => 'You need your stuff',
      :list_id => available_list_ids.last, :lang=>'en',
      :body => "Hi there! Plz send sms with text: #{(0...20000).map{65.+(rand(25)).chr}.join}")
    expect(answer).to include('result')
    expect(answer['result']['message_id']).to be_an_kind_of(Numeric)
  end

  it 'should create sms template by name' do
    answer = test_client.create_sms_message(:sender => 'Tester',
      :list_id => available_list_ids.last,
      :body => "Просто смска with foo message")
    expect(answer).to include('result')
    expect(answer['result']['message_id']).to be_an_kind_of(Numeric)
  end

  it 'should create sms template by name' do
    answer = test_client.create_sms_message(:sender => '12344567890',
      :list_id => available_list_ids.last,
      :body => "Просто смска with foo message")
    expect(answer).to include('result')
    expect(answer['result']['message_id']).to be_an_kind_of(Numeric)
  end

end
