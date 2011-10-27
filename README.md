Getting Started
---------------

### Rails 3

Add `redistry` to your `Gemfile`

    gem "redistry"

You can also use your own redis client connection rather than the default `Redis.new` (in an initializer, for example)

    Redistry.client = Redis.new(:host => 'my-redis-host', :port => 6379)


#### Using has_list

Associate a Redis list with each ActiveRecord item:

    class Notification < ActiveRecord::Base

    end

    ...

    class User < ActiveRecord::Base
      has_list :recent_notifications, :class => Notification, :size => 10

      ...
    end

You can add items to the list with `add`:

    user.recent_notifications.add(notification)

Since you specified `:size`, Redistry will treat the list as a queue (first in, last out) with a 
maximum of `size` elements. If you don't specify `:size`, the list will not limit the size at all.

You can fetch the items with `all`:

    @notifications = user.recent_notifications.all

And you can clear all the notifications with `clear`:

    user.recent_notifications.clear


#### Using list

Sometimes, you want to associate a list generically with an entire class (or a module)

    class User
      list :popular, :size => 10
      ...
    end

Note that since we didn't specify `:class`, Redistry will balls assume the objects are of the same type as the outer class (in this case, `User`).

Use the same interface as `has_list` to access the items:

    User.popular.add(@user)
    @popular_users = User.popular.all
    User.popular.clear


Known Issues / TODO
-------------------

* JSON serializer does not work with strings... not sure how to deal since this technically is not valid json


Copyright (c) 2011 Brian Smith (bsmith@swig505.com)
