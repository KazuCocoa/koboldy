# Koboldy

Support library for kobold https://github.com/yahoo/kobold

- Generate kobold-configuration
- Run and analyse the result

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'koboldy'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install koboldy

## Usage

### Install kobold

`koboldy` is support library of **kobold** which is image comparing library for npm.

https://github.com/yahoo/kobold

### Create configuration file

```ruby
Koboldy::Conf.instance.add_block_out(0, 0, 0, 0)
             .add_block_out(50, 50, 50, 50)
             .add_block_out_red(255)
             .add_compose_left_to_right(true)
             .generate_into("config_file.txt")

> cat config_file.txt
{
  "blockOut": [
    {
      "x": 0,
      "y": 0,
      "width": 0,
      "height": 0
    },
    {
      "x": 50,
      "y": 50,
      "width": 50,
      "height": 50
    }
  ],
  "blockOutRed": 255,
  "composeLeftToRight": true
}
```

### Run with command

```ruby
@run = Koboldy::Run.new("kobold")
cmd = @run.config("config_file")
          .approved("expected_folder")
          .highlight("compared_folder")
          .build("test_target_folder")
          .fail_orphans
          .fail_additions
          .base_uri(`pwd`)

> "kobold --config config_file --approved-folder expected_folder" +
    " --highlight-folder compared_folder --build-folder test_target_folder --fail-orphans --fail-additions path"

cmd.check_and_save("result.txt")
```

### Get results

```ruby
@run.results("result.txt")

>
{
  "passing": 250,
  "failing": 101,
  "pending": 0,
  "additions": {
    "count": 2,
    "messages": [
      "0004_03_01_bargain_store_details",
      "0017_01_05_open_contact5"
    ]
  },
  "orphans": {
    "count": 3,
    "messages": [
      "0000_01_03_hot_recommend",
      "0102_02_01_open_recipe_2446163",
      "0102_02_02_open_tukurepo_2446163"
    ]
  },
  "different": {
    "count": 2,
    "messages": [
      "0000_01_04_recent",
      "0000_01_05_my_folder"
    ]
  }
}
```


## Contributing

1. Fork it ( https://github.com/KazuCocoa/koboldy/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
