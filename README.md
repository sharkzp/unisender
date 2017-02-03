# UniSender [![Build Status](https://travis-ci.org/sharkzp/unisender.svg?branch=master)](https://travis-ci.org/sharkzp/unisender)

uni_sender gem provides full ruby dev kit to access API of [unisender.com.ua](http://unisender.com.ua). It uses `method_missing` to provide flexible functionality. All methods will return hash that represents response from the server. To experiment with the code, run `pry` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'uni_sender'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install uni_sender

## Usage

Gem provides class `UniSender::Client` for accessing server's API. For creating client you need your personal key

```ruby
client = UniSender::Client.new("your secret key")
```

Sandbox mode API key `"2pF44VzCfXmNSVOJtMhgBTLzTWlZokU8w"`

```ruby
client = UniSender::Client.new("2pF44VzCfXmNSVOJtMhgBTLzTWlZokU8w")
```

Retrieve mailing lists with their codes

```ruby
client.get_lists
```

Create a new mailing list

```ruby
client.create_list({ :title => "NewListTitle" })
```

Subscribe addressee on one or several mailing lists

```ruby
client.subscribe({
  :list_ids => [1, 2],
  :fields => {
    :email => "dougal.mcguire@example.com",
    :phone => "+380987654321",
    :name => "Dougal"
  }
})
```

Create an e-mail to a mass mailing

```ruby
client.create_email_message({
  :sender_name => "Test Name",
  :sender_email => "test@example.com",
  :list_id => 1,
  :lang => "en",
  :subject => "Subject",
  :body => "Body"
})
```

Sending individual email message

```ruby
client.send_email({
  :sender_name => "Test Name",
  :sender_email => "test@example.com",
  :list_id => 1,
  :lang => "en",
  :subject => "Subject",
  :body => "Body",
  :email => "receiver@example.com"
})
```

Create SMS for mass mailing

```ruby
client.create_sms_message({
  :sender => "CompanyName",
  :list_id => 1,
  :body => "Sample SMS message"
})
```

Send SMS-message

```ruby
client.create_sms_message({
  :phone => "+380987654321",
  :sender => "MyCompany",
  :list_id => 1,
  :body => "Sample SMS message",
  :text => "Hello, it's a test message"
})
```

Gem provides non-sensitive style, so action `getLits` will equal to `get_lists`

For getting contacts call `client.exportContacts` (or `client.export_contacts`). If request will be accepted client will return hash in the next format:

```ruby
{ 'result' => { 'field_names' => [...], 'data' => [[...], [...], ... ] } }
```

Before sent action to server gem processes all parameters.

If parameter is array, `uni_sender` will join contents by comma, also process all items like string

`{ :sample => [233, 'foo', 545] }` will be transformed to `sample=233,foo,545`

`Hash` will be encoded into nested variables, for example:

`{ :friend => { :name => "Роман", :car => "BMW" } }` will be `friend[name]=Роман&friend[car]=BMW`

Keep in mind, that `field_names` and `data` for API method `importContacts` translated in the different way

    field_names[0]=email&field_names[1]=email_list_ids&
    data[0][0]=a@example.com&data[0][1]=123&data[1][0]=b@example.org

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests. You can also run `pry` for an interactive prompt that will allow you to experiment.

## Wiki

For more information about API methods please visit:

[General information about UniSender API](https://support.unisender.com/index.php?/Knowledgebase/Article/View/49/0/obshaya-informaciya-pro-unisender-api)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sharkzp/uni_sender. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
