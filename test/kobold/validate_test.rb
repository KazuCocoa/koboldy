require "test/unit"

require "./lib/koboldy/validate"

class ValidateTest < Test::Unit::TestCase
  test "#validate_kobold_result is invalid" do
    test_string =<<-EOS
module.js:340
    throw err;
          ^
Error: Cannot find module 'graceful-fs'
    at Function.Module._resolveFilename (module.js:338:15)
    at Function.Module._load (module.js:280:25)
    at Module.require (module.js:364:17)
    at require (module.js:380:17)
    EOS

    assert_raise(::Koboldy::NoJsModuleError) do
      ::Koboldy::Command.validate_installation(test_string)
    end
  end

  test "#validate_kobold_result is valid" do
    test_string =<<-EOS
ok
    EOS

    assert_equal "ok\n", ::Koboldy::Command.validate_installation(test_string)
  end
end
