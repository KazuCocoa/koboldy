require "test/unit"
require "rantly"

require "./lib/koboldy/conf"

class TestKobold < Test::Unit::TestCase
  def setup
    @kobold ||= Koboldy::Conf.instance
  end

  def teardown
    @kobold.clear_config
  end

  data(                      #  x       y     width    height
    "test1" => Rantly { [integer, integer, integer, integer] })
  test "#add_block_out" do |(x, y, width, height)|
    expected = [{ x: x, y: y,width: width, height: height }]
    @kobold.add_block_out(x, y, width, height)
    assert_equal(@kobold.config["blockOut"], expected)

    expected.push({ x: x, y: y,width: width, height: height })
    @kobold.add_block_out(x, y, width, height)
    assert_equal(@kobold.config["blockOut"], expected)
  end

  data(          # on/off
    "test1" => [true],
    "test2" => [false])
  test "#add_hide_shift" do |(boolean)|
    @kobold.add_hide_shift boolean
    assert_equal(@kobold.config["hideShift"], boolean)
  end


  data(          # on/off
    "test1" => [true],
    "test2" => [false])
  test "#add_compose_left_to_right" do |(boolean)|
    @kobold.add_compose_left_to_right boolean
    assert_equal(@kobold.config["composeLeftToRight"], boolean)
  end

  data(       # expected  value
    "test1" => [  0,     -1],
    "test2" => [  0,      0],
    "test3" => [255,    255],
    "test4" => [255,    256])
  test "#add_block_out_red" do |(expected, actual)|
    @kobold.add_block_out_red actual
    assert_equal(@kobold.config["blockOutRed"], expected)
  end

  data(       # expected  value
    "test1" => [  0,     -1],
    "test2" => [  0,      0],
    "test3" => [255,    255],
    "test4" => [255,    256])
  test "#add_block_out_blue" do |(expected, actual)|
    @kobold.add_block_out_blue actual
    assert_equal(@kobold.config["blockOutBlue"], expected)
  end

  data(       # expected  value
    "test1" => [  0,     -1],
    "test2" => [  0,      0],
    "test3" => [255,    255],
    "test4" => [255,    256])
  test "#add_block_out_green" do |(expected, actual)|
    @kobold.add_block_out_green actual
    assert_equal(@kobold.config["blockOutGreen"], expected)
  end



  test "add some items" do
    @kobold.add_block_out(0, 0, 0, 0)
      .add_block_out(50, 50, 50, 50)
      .add_block_out_red(255)
      .add_compose_left_to_right(true)

    expected =<<-EOS.chomp
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
    EOS
    assert_equal(JSON.pretty_generate(@kobold.config.to_h), expected)
  end


end