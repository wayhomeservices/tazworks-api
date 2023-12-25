# Tazworks::Api

Simple API wrapper implementation for Tazworks RESTful JSON Background/Credit Screening API version 2 found [here](https://docs.developer.tazworks.com/).

This gem implements a very limited set of endpoints that we needed for our use case. PRs welcome for expanding the number of implemented endpoints!

[![Gem Version](https://badge.fury.io/rb/tazworks-api.svg)](https://badge.fury.io/rb/tazworks-api)
[![Build Status](https://github.com/wayhomeservices/tazworks-api/actions/workflows/main.yml/badge.svg)](https://github.com/wayhomeservices/tazworks-api/actions/workflows/main.yml/badge.svg)

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add tazworks-api

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install tazworks-api

## Usage


### Configuration

Load the tazworks gem and set the configuration:

```
require 'tazworks'

Tazworks.configure do |c|
  c.api_key = 'your_api_key'

  # set this to true if you want to use the sandbox host, otherwise, defaults to production
  #c.sandbox = true 
end
```

### Calls

Tazworks utilize pascalCase. As this is only a lightweight wrapper, all parameters must be passed as pascalCasing instead of ruby idiomatic snake_casing.


General Workflow:
```ruby
# querying client
@clientGuid = 'MY_CLIENT_GUID'
client=Tazworks::Client.find(@clientGuid)
# OR
client=Tazworks::Client.all.clients.first

# view the client attributes
client.attributes

# querying the client products
client_product = client.client_products.client_products.first

# view the client_product attributes
client_product.attributes

# creating a new applicant
applicant = client.create_applicant( { firstName: 'Bob', lastName: 'Smith', email: 'bob.smith@gmail.com' } )

# view the applicant attributes
applicant.attributes

# submitting order
order = client.submit_order({applicantGuid: applicant.applicantGuid, clientProductGuid: client_product.clientProductGuid, useQuickApp: true})

# view the order attributes
order.attributes

# get the quickappApplicantLink
order.quickappApplicantLink

# checking order status
order.order_status

# getting pdf results for order (will only work after order goes to 'complete' status)
order.results_as_pdf
```

Until rubydocs are written, the best bet is to look at the source for usage information, especially the specs folder where most of the implemented endpoints have been tested.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

To regenerate or record new [vcr](https://benoittgt.github.io/vcr/) cassettes, set the `TAZAPI_KEY` environment variable:

```
export TAZAPI_KEY=myfancykey

bin/rspec
``` 



## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wayhomeservices/tazworks-api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/wayhomeservices/tazworks-api/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Tazworks::Api project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/wayhomeservices/tazworks-api/blob/master/CODE_OF_CONDUCT.md).
