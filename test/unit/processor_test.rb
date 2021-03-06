require File.dirname(__FILE__) + "/../../lib/roger_requirejs/processor"
require "test/unit"

class ProcessorTest < Test::Unit::TestCase

  def test_require_js_default_fallback
    # When the user points the requirejs processer to a wrong file
    # it should throw an RunTimeError
    options = {:rjs => "s.js"}
    requirejs_processor = RogerRequirejs::Processor.new(options)
    rjs = options[:rjs]

    rjs_command = ''

    assert_raise RuntimeError do
      # The file does is there - it's this one, so it should raise
      rjs_command = requirejs_processor.rjs_check
    end

    # No command string is returned
    assert_equal rjs_command, ""
    
  end
  
  def test_require_js_bin
    # When no default require.js path is given we expect it to be r.js availble in $PATH
    requirejs_processor = RogerRequirejs::Processor.new
    rjs = "r.js" # Default r.js by npm

    begin
      `#{rjs} -v`
    rescue Errno::ENOENT
      assert_raise RuntimeError do
        requirejs_processor.rjs_check
      end
    else
      assert_equal requirejs_processor.rjs_check, rjs
    end
    
  end
  
  def test_require_js_lib
    # Just point options[:rjs] to a file to look if its there,
    # the user is expected to point to a correct r.js file if he
    # doesn't want to use the r.js shipped with npm
    options = {:rjs => __FILE__}
    requirejs_processor = RogerRequirejs::Processor.new(options)
    rjs = options[:rjs]

    rjs_command = ''

    assert_nothing_raised RuntimeError do
      # The file  is there - it's this one in fact, so it shouldn't raise
      rjs_command = requirejs_processor.rjs_check
    end

    assert_equal rjs_command, "node #{rjs}"
    
  end
  
end
