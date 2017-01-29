# Trial day

Small web framework for writing simple JSON APIs. Based on Rack.

## Installation

```
git clone git@github.com:madeinussr/trial.git
```

## Usage

Define actions in the `config.ru` file:

```ruby
# config.ru

require 'trialday'

get '/bla' do
  { results: [1, 2, 3] }
end

post '/bla' do |params|
  name = params[:name]
  { name: name }
end
```

Start the server:

```
bundle exec rackup --port 3000
```

Make requests:

```
curl http://localhost:3000/bla -i
```

```
curl -XPOST http://localhost:3000/bla -i -H "Content-Type: application/json" -d '{"name": "Mario"}'
```

## Tests

```
bundle exec rspec
```