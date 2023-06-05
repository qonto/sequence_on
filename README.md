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

To publish a new version to rubygems, switch to a new branch named after the version you want to publish,
for instance `v0.3.0`, update `lib/sequence_on/version.rb` to this version, and open a new merge request.
Once merged, a new release will be created.
