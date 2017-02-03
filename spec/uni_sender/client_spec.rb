# encoding: utf-8
require 'spec_helper'

describe UniSender::Client do
  let(:client) { UniSender::Client.new("2pF44VzCfXmNSVOJtMhgBTLzTWlZokU8w") }
  let(:available_list_ids) { client.getLists['result'].map { |list| list['id'].to_i } }

  context 'invalid API key' do
    it 'should get invalid key error' do
      answer = UniSender::Client.new("123abcd123").getLists
      expect(answer['error']).to be_truthy
      expect(answer['code']).to eq 'invalid_api_key'
    end
  end

  context 'unknown API method' do
    it 'raises NoMethodError if called not supported API method' do
      expect { client.unknownMethod }.to raise_error NoMethodError, 'Unknown API method unknownMethod'
    end
  end

  describe '#create_email_message' do
    it 'should create email template' do
      answer = client.create_email_message(
        :sender_name => 'Ваня Петров',
        :sender_email => 'uni.sender.gem@gmail.com',
        :list_id => available_list_ids.last,
        :lang => 'en',
        :subject => 'You need your stuff',
        :body => "Привет дорогой друг!")
      expect(answer).to include('result')
      expect(answer['result']['message_id']).to be_a_kind_of(Integer)
    end

    it 'should create email template with long body' do
      answer = client.create_email_message(:sender_name => 'Ivan Petrov',
        :sender_email => 'uni.sender.gem@gmail.com',
        :subject => 'You need your stuff',
        :list_id => available_list_ids.last,
        :lang=>'en',
        :body => "Hi there! Plz send sms with text: #{(0...20000).map{65.+(rand(25)).chr}.join}")
      expect(answer).to include('result')
      expect(answer['result']['message_id']).to be_a_kind_of(Integer)
    end
  end

  describe '#send_email' do
    it 'sends individual email' do
      answer = client.create_email_message(
        :sender_name => 'MyCompany',
        :sender_email => 'uni.sender.gem@gmail.com',
        :list_id => available_list_ids.last,
        :lang => 'en',
        :email => 'dougal.mcguire@example.com',
        :subject => 'Email Subject',
        :body => "This is a test message."
      )
      expect(answer).to include('result')
      expect(answer['result']['message_id']).to be_a_kind_of(Integer)
    end
  end

  describe '#create_sms_message' do
    it 'should create SMS template by name' do
      answer = client.create_sms_message(
        :sender => 'MyCompany',
        :list_id => available_list_ids.last,
        :body => "Просто смска with foo message")
      expect(answer).to include('result')
      expect(answer['result']['message_id']).to be_a_kind_of(Integer)
    end
  end

  describe '#send_sms' do
    it 'sends individual SMS message' do
      answer = client.send_sms(
        :sender => 'MyCopany',
        :phone => '+380987654321',
        :list_id => available_list_ids.last,
        :body => "Просто смска with foo message")
      expect(answer).to include('result')
      expect(answer['result']['sms_id']).to be_a String
      expect(answer['result']['phone']).to eq("+380987654321")
      expect(answer['result']['price']).to be_a Float
      expect(answer['result']['currency']).to be_a String
    end
  end

  describe '#getLists' do
    it "should get collection of contact's list" do
      answer = client.getLists
      expect(answer['result'].size).to eq 3
      expect(answer['result'].map { |item| item['title'] }).to include('unisender_spec', 'test_sender')
    end
  end

  describe '#createLists' do
    it 'should test creation of list' do
      answer = client.createList(:title => 'sample_title')
      expect(answer['result']['id']).to be_a_kind_of(Integer)
      answer = client.createList(:title => 'Кириллица тоже')
      expect(answer['result']['id']).to be_a_kind_of(Integer)
    end
  end

  describe '#subscribe' do
    it 'subscribe person to lists' do
      answer = client.subscribe(:list_ids => available_list_ids,
        :fields => { :email => 'sam@parson.com', :phone => '+72345678900',
        :twitter => 'sammy', :name => 'Сеня Парсон' })
      expect(answer['result']['person_id']).to be_nil
    end
  end

  describe '#unsubscribe' do
    it 'should unsubscribe from lists by email' do
      answer = client.unsubscribe(:contact_type => 'email', :contact => 'test@mail.com')
      expect(answer).not_to include('error')
      expect(answer).to include('result')
    end

    it 'should unsubscribe from lists by phone' do
      answer = client.unsubscribe(:contact_type => 'phone', :contact => '+11111111111')
      expect(answer).not_to include('error')
      expect(answer).to include('result')
    end
  end

  describe '#activateContacts' do
    it 'should activate contacts' do
      answer = client.activateContacts(:contact_type => 'email', :contacts => ['test@mail.com', 'john@doe.com'])
      expect(answer).to include('result')
      # answer['result']['activated'].should == 2 falls because of rating or test mode
    end
  end

  describe 'dynamically defined methods' do
    it 'defines method after first call' do
      client.createList(:title => 'first_title')
      expect(client).respond_to? :createList
      answer = client.createList(:title => 'second_title')
      expect(answer['result']['id']).to be_a_kind_of(Integer)
    end

    specify 'defined method internally uses default_request method' do
      client.createList(:title => 'first_title')
      expect(client).to receive(:default_request).with("createList", {:title=>"second_title"})
      client.createList(:title => 'second_title')
    end
  end
end
