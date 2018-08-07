# Axt
Axt is a tool I'm building to compare parser gem and `RubyVM::AST.parse` builtin function.

![axt usage](https://pbs.twimg.com/media/Dj9eW4SXoAIuqEw.jpg:large)


## Usage
```
git clone git@github.com:jonatas/axt.git
cd axt
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that 

$ echo 'puts "hello"' | bin/axt
```
(fcall puts
(array "hello"
 (str "hello")))
```

I'm almost building to compare with [parser](https://github.com/whitequark/parser) results and see if it can be a good use case for migrating the parser for [fast](https://github.com/jonatas/fast).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jonatas/axt. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Axt project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/axt/blob/master/CODE_OF_CONDUCT.md).
