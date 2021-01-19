# axentro-util

A utility to create and post a signed transaction for sending AXNT tokens on [Axentro Blockchain](https://axentro.io)

[![CircleCI](https://circleci.com/gh/Axentro/axentro-util.svg?style=svg)](https://circleci.com/gh/Axentro/axentro-util)


## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     axentro-util:
       github: axentro/axentro-util
   ```

2. Run `shards install`

## Usage

```crystal
require "axentro-util"

from_address = "VDAwZTdkZGNjYjg1NDA1ZjdhYzk1M2ExMDAzNmY5MjUyYjI0MmMwNGJjZWY4NjA3"
from_public_key = "3a133bb891f14aa755af119907bd20c7fcfd126fa187288cc2b9d626552f6802"
wif = "VDAwYjIxODI2NDg3MDE3YjA2YTYxOTJiYjUzMjg0MDAzZWNkZGRhZDJlYmUwNjMxYWM3NmIwMzFlYTg4MjlkMTBhMzBkZmNk"
to_address = "VDBjY2NmOGMyZmQ0MDc4NTIyNDBmYzNmOWQ3M2NlMzljODExOTBjYTQ0ZjMxMGFl"
amount = "1"

# generate a signed transaction from the supplied data    
transaction = Axentro::Util.create_signed_send_transaction(from_address, from_public_key, wif, to_address, amount)

# post the transaction to the desired server
transaction_id = Axentro::Util.post_transaction(transaction, "https://testnet.axentro.io")
```

## Contributing

1. Fork it (<https://github.com/your-github-user/axentro-util/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Kingsley Hendrickse](https://github.com/kingsleyh) - creator and maintainer
