![Gem Version](https://badge.fury.io/rb/sequence_on.svg)

# sequence_on

It is a replacement for act_as_sequence, where you can specify a lambda to determine how to generate the scope.

# UPGRADE

## Version 0.1.0
This version removes global lock on a table and uses `pg_advisory_lock`.

[Breaking change]

Now `sequenced_on` lambda accepts only hash of parameters and not ActiveRecord objects:
```ruby
sequenced_on ->(r) { { bank_account_id: r.bank_account_id } }
```

instead of:
```ruby
sequenced_on ->(r) { where(bank_account_id: r.bank_account_id) }
```

# Releasing

To publish a new version to rubygems, update the version in `lib/sequence_on/version.rb`, and merge.
