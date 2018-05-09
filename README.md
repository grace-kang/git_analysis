# GitAnalysis

A RubyGem that analyzes a git repository and outputs basic information and PR information.

Upon running app.rb with a repository URL, the following will be outputed:

1. Repository Information
2. Number of Pull Requests
3. Pull Request Sizes


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'git_analysis'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git_analysis

## Basic Usage

### Set your environment variable 'TOKEN' as your token by executing:

    $ export TOKEN=[your token]
 
### Include the following line in your application:

```ruby
require 'git_analysis'
```

### Create a GitAnalyzer object:

```ruby
analyzer = GitAnalysis::GitAnalyzer.new([URL])
```

Format of the URL: https://github.com/[owner]/[repo]

### Functions:

```ruby
# basic repository information
repo_id = analyzer.id
repo_name = analyzer.name
repo_owner = analyzer.owner
repo_language = analyzer.language

# pull request count
open_prs = analyzer.get_open_pr_count
closed_prs = analyzer.get_closed_pr_count
total_prs = analyzer.get_total_pr_count

# print functions
analyzer.print_basic_info # prints id, name, owner, language
analyzer.print_num_prs # prints open, closed, and total pr count
analyzer.print_pr_sizes # prints each pr's size
analyzer.print_contributors # prints each contributor's contributions and percentage
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/grace-kang/git_analysis. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GitAnalysis project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/git_analysis/blob/master/CODE_OF_CONDUCT.md).
