# FriendlyUUID
FriendlyUUID is a Rails gem that shortens your UUID records' URLs.

What once was
```http
twos.dev/users/758d633c-61d4-4dfc-ba52-b7b498971097
```
becomes
```http
twos.dev/users/758d
```

FriendlyUUID does not introduce any new state to your models, even under the
hood.

FriendlyUUID URLs are exactly as unique as they need to be. The first record
will be one character. Would-be collisions expand to two characters, and so
on.

FriendlyUUID is inspired by [norman/friendly_id][1], but is focused on being
lightweight and specific to models with UUID primary keys.

## Installation
Add it to your Gemfile:
```ruby
gem 'friendly_uuid'
```
Then include it in any model that has UUID primary keys:
```ruby
class User < ApplicationRecord
  include FriendlyUUID
  # ...
end
```
And you're done! URL helpers will automatically generate shorter URLs and
your model's `find` and `find_by` methods will behave as expected when given
short UUIDs.

[1]: https://github.com/norman/friendly_id

## FAQ
### How does it work?
The core idea of FriendlyUUID is to truncate UUIDs until they are the
shortest possible unique string.

However this approach has some nuance, demonstrated by the following
operations:
```
1. Create record A with UUID abcdefg (shortened to a)
2. Create record B with UUID abcabca (shortened to abca)
```
After step 1, record `A` has a URL like `twos.dev/users/a`. After step 2,
that same record has a URL like `twos.dev/users/abcd`. This causes two
problems:

- `A`'s URL has changed! But _[cool URLs don't change][2]_.
- Where should `twos.dev/users/a` lead now?

To address this nuance, FriendlyUUID cleverly truncates URLs _past_
uniqueness. It keeps truncating characters _as long as the URL remains the
eldest among its collisions_.

In other words, after the above example, `A`'s URL continues to be
`twos.dev/users/a`, because when its UUID is truncated to `a` it remains the
_eldest of all records whose UUIDs start with `a`_.

And when `twos.dev/users/a` is accessed, FriendlyUUID knows that the record
being asked for is the _eldest record_ that starts with `a`.

With this tweak, records always have the shortest possible URL, their URLs
never change, and one URL always points to one record—all conventional rules
about URLs are followed, and no extra state was stored!

[2]: https://www.w3.org/Provider/Style/URI

#### Disadvantages
There are two disadvantages to this approach.

1. As with many stateless algorithms, you pay in machinepower. In this case, the
queries to discover the shortest-possible URL are quite expensive compared to
O(1) lookups. (The query to discover a record _given_ a URL remains cheap.)

2. Deleting record `A` in the above example will cause `twos.dev/users/a` to
point to `B`, rather than to 404 as a user might expect. You can work around
this by choosing to soft-delete records whenever you would normally
hard-delete them.

### Why use UUIDs?
There are a few of reasons you might want to use UUIDs as primary keys over
numeric IDs.

#### So you don't expose how many records you have
Using auto-incrementing numeric IDs means anyone can discover roughly how
many users/articles/customers/etc. you have.

Even if you replace URL IDs with something else you are probably still
leaking IDs without realizing it, as many Rails constructs (e.g. `form_with`)
will insert IDs into your HTML.

IDs serve an important role and _you should not feel afraid of using them
anywhere_. But with auto-incrementing numeric IDs you could be inadvertently
sharing information about e.g. the success of a product to a competitor or
bad actor.

#### Because you're working with distributed systems
When using numeric IDs in distributed systems, you may have several layers of
services waiting on the ID-generating service to finish before they can act
further on it, such as waiting on a user object to be created before they
update another service with details about the user.

When using UUIDs the consuming service can generate the UUID itself, and
simultaneously tell all the appropriate services the relevant details about
it. This does not depend on one service to finish creating the record first,
therefore the creation is faster and resilient to partial outages.

#### Because you're working with high-throughput systems
When using numeric IDs, each ID must be exactly the previous ID plus 1. If
the ID-generating service has very high throughput, performing this operation
in a concurrent-safe way can become a bottleneck, as each request must wait
for all previous requests to be served.

When using UUIDs, ID generation can be parallelized as no one request depends
on any previous request's state.

### What if I am already serving production traffic with full UUIDs in URLs?
Existing links that use full UUIDs will not be broken. Because of the
algorithm FriendlyUUID uses to lengthen shortened UUIDs, a full-length UUID
is still considered a valid shortening of itself.

This means that after installing FriendlyUUID, each resource may have
multiple valid URLs. Rails URL helpers will behave correctly and always
return the same canonical short URL, but if there are full-form links in the
wild (like on Twitter) that you want to be canonicalized you can optionally
decide to forward them:

```ruby
class UsersController < ApplicationController
  before_action :canonicalize_path, only: [:show, :edit]

  # ...

  private

  def canonicalize_path
    canonical_path = user_path(@user)
    redirect_to canonical_path if canonical_path != request.fullpath
  end
end
```

Whether or not you take this step, no links will be broken by adding
FriendlyUUID to your app.

## Contributing
See [CONTRIBUTING.md][contributing]

[contributing]: https://github.com/glacials/friendly_uuid/blob/main/CONTRIBUTING.md
