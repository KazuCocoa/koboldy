require "test/unit"

require "./lib/koboldy/run"

class RunTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @run = Koboldy::Run.new("kobold")
  end

  def teardown
    # Do nothing
  end


  def test_cmd_configuration
    expected = %(kobold --config "a" --approved-folder "b" --highlight-folder "c" --build-folder "d" --fail-orphans --fail-additions "neko")
    cmd = @run
            .config("a")
            .approved("b")
            .highlight("c")
            .build("d")
            .fail_orphans
            .fail_additions
            .base_uri("neko")
    assert_equal(cmd, expected)
  end

  def test_result_check
    expected = <<-EOS.chomp
{
  "passing": 250,
  "failing": 101,
  "pending": 0,
  "additions": {
    "count": 2,
    "messages": [
      [
        "Screen is new: 0004_03_01_bargain_store_details"
      ],
      [
        "Screen is new: 0017_01_05_open_contact5"
      ]
    ]
  },
  "orphans": {
    "count": 3,
    "messages": [
      [
        "Error: Approved screen is orphaned: 0000_01_03_hot_recommend"
      ],
      [
        "Error: Approved screen is orphaned: 0102_02_01_open_recipe_2446163"
      ],
      [
        "Error: Approved screen is orphaned: 0102_02_02_open_tukurepo_2446163"
      ]
    ]
  },
  "different": {
    "count": 2,
    "messages": [
      [
        "Error: Screens are different for 0000_01_04_recent"
      ],
      [
        "Error: Screens are different for 0000_01_05_my_folder"
      ]
    ]
  }
}
EOS
    result = @run.results("./test/data/kobold_test_data.txt")
    assert_equal(result, expected)
  end
end