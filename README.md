# OptimusPrimer

A simple gem and associated command line tool to allow switching between Intel and dedicated Nvidia GPUs in Optimus configurations.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'optimus_primer'
```

And then execute:

    $ bundle

Or install it yourself for system-wide use, along with required config files using:

    # make

## Usage

`bin/optimus-primer -m intel|nvidia`

Reboot, and the selected GPU will be in use.  Confirm this with `glxinfo | grep render`

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

Given where this gem writes to, you will need to run under sudo.  For running under rvm and debugging:
```
rvmsudo_secure_path=1 rvmsudo rdebug-ide -- bin/optimus-primer --mode intel|nvidia
```

For vscode, you should now be able to create a `Listen for rdebug-ide` debug config:
```
        {
            "name": "Listen for rdebug-ide",
            "type": "Ruby",
            "request": "attach",
            "remoteHost": "127.0.0.1",
            "remotePort": "1234",
            "remoteWorkspaceRoot": "${workspaceRoot}"
        }
```

This will allow you to debug the application and write to relevant paths without running vscode (or other) under sudo.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/m-dwyer/optimus_primer.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
