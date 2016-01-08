#encoding: utf-8
require 'spec_helper'

describe UniSender::Client do

  it "should get collection of contact's list" do
    answer = test_client.getLists
    expect(answer['result'].size).to eq 3
    expect(answer['result'].map { |item| item['title'] }).to include('unisender_spec', 'test_sender')
  end

  it 'should test creation of list' do
    answer = test_client.createList(:title => 'sample_title')
    expect(answer['result']['id']).to be_an_kind_of(Numeric)
    answer = test_client.createList(:title => 'Кириллица тоже')
    expect(answer['result']['id']).to be_an_kind_of(Numeric)
  end

  it 'subscribe person to lists' do
    answer = test_client.subscribe(:list_ids => available_list_ids,
      :fields => {:email => 'sam@parson.com', :phone => '+72345678900',
      :twitter => 'sammy', :name => 'Сеня Парсон'})
    #answer['result']['person_id'].should be_an_kind_of(Numeric)
    expect(answer['result']['person_id']).to be_falsey
  end

  it 'should unsubscribe from lists by email' do
    answer = test_client.unsubscribe(:contact_type => 'email', :contact => 'test@mail.com')
    expect(answer).not_to include('error')
    expect(answer).to include('result')
  end

  it 'should unsubscribe from lists by phone' do
    answer = test_client.unsubscribe(:contact_type => 'phone', :contact => '+11111111111')
    expect(answer).not_to include('error')
    expect(answer).to include('result')
  end

  it 'should activate contacts' do
    answer = test_client.activateContacts(:contact_type => 'email', :contacts => ['test@mail.com', 'john@doe.com'])
    expect(answer).to include('result')
    #answer['result']['activated'].should == 2 falls because of rating or test mode
  end

end
