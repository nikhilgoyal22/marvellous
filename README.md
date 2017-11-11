# Marvellous
Marvel API Gem

Ruby wrapper for Marvel Comics API.

## Installation

Add this line to your application's Gemfile:

    gem 'marvellous'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install marvellous

## Usage

Please register first in the [Marvel Comics Developer
Portal](http://developer.marvel.com/) to get your API credentials (a public key
and a private key, you'll need them both to configure and instantiate a client).

### Instantiate a client

```ruby
client = Marvellous::Client.new( :public_key => 'abcd1234', :private_key => '5678efgh')

# fetch a list of characters (https://developer.marvel.com/docs#!/public/getCreatorCollection_get_0)
client.characters # by default pagination of 10 items is implemented
client.characters({page_size: 20, page_num: 2}) # to change the default pagination settings
client.characters({paginate: false}) # to turn off pagination

# fetch a single character by characterId (https://developer.marvel.com/docs#!/public/getCreatorCollection_get_0)
client.character({id: 1009610})
