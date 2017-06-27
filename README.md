## Show Code ##

show_code provides a quick way to show ruby method source codes in terminal.

__NOTE__: show_code current version *require* Ruby v1.9.0 or later.

### Installation ###
    # Installing as Ruby gem
    $ gem install show_code

    # Or in gemfile
    $ gem show_code

### Usage ###
You can use show_code in `console c` or `irb`

```ruby
require "show_code" # just when use irb
ShowCode method_object
# or
ShowCode method_string
```

### Examples ###

#### show code
```ruby
ShowCode 'ShowCode::Code.new.greet'

#     def greet
#       puts 'Hello ShowCode!'
#     end
# => #<UnboundMethod: ShowCode::Code#greet>

# also you can use this way, it does the same thing
ShowCode ShowCode::Code.instance_method(:greet)

```
#### open resource file
Sometimes, we wanna open the resource file to edit, as default `gedit` will open the file.

```ruby
ShowCode.open 'ShowCode::Code.new.greet'
# or ShowCode.open ShowCode::Code.instance_method(:greet)
```

### TODO ###
- Colorize output
- Add more statistic analysis in output

### License ###
Released under the [MIT](http://opensource.org/licenses/MIT) license. See LICENSE file for details.
