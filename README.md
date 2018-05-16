# GitAnalysis

A RubyGem that analyzes a git repository and outputs basic information and PR information.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'git_analysis'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git_analysis

## Usage

**Set your environment variable 'CHANGELOG_GITHUB_TOKEN' as your token by executing:**

    $ export CHANGELOG_GITHUB_TOKEN=[your token]

  Note: You may proceed without this step but you are only allowed 50 requests per hour and may get an exception (GitAnalysis::RepositoryError - API rate limit exceeded) if you reach this limit.
 
**Include the following line in your application:**

```ruby
require 'git_analysis'
```

**Create an Authorization object:**

```ruby
# NOTE: any requests made returning status codes 404, 401, and 429 will raise a GitAnalysis::ResponseError and won't be handled
auth = GitAnalysis::Authorization.new(owner, repo_name)

# create Repository objecy
repo = auth.create_repo

# create GitAnalysis::PullRequest object from valid PR number
pr = auth.create_pr(pr_number)

# returns a list of the repository's PR numbers given the PR state
open_pr_numbers = auth.pr_number_list('open')
```

**GitAnalysis::Repository class attributes:**
```ruby
repo_id = repo.id
repo_name = repo.name
repo_owner = repo.owner
repo_language = repo.language
```

**GitAnalysis::PullRequest class attributes:**
```ruby
pr_number = pr.number
pr_owner = pr.owner
pr_file_count = pr.file_count
pr_additions = pr.additions
pr_deletions = pr.deletions
pr_changes = pr.changes
```

**Usage Example - GitAnalysis::Printer**

Run the following to see an example of Printer in action:

    $ bundle exec ruby app.rb [enter owner] [enter repo name]


```ruby
# create a printer object
printer = GitAnalysis::Printer.new(repo_object, open_pr_count, closed_pr_count)

# print functions
analyzer.print_basic_info # prints id, name, owner, language
analyzer.print_num_prs # prints open, closed, and total pr count
analyzer.print_pr_size(pr_object) # prints a given pr's size
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
