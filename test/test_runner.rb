require 'test/unit/testcase'

if defined?(MiniTest)
  require File.expand_path('../mini_test_result', __FILE__)
else
  require File.expand_path('../test_unit_result', __FILE__)
end

module TestRunner
  def run_as_test(&block)
    run_as_tests(:test_me => block)
  end

  def run_as_tests(methods = {})
    test_class = Class.new(Test::Unit::TestCase) do
      methods.each do |(method_name, proc)|
        define_method(method_name, proc)
      end
    end
    tests = methods.keys.select { |m| m.to_s[/^test/] }.map { |m| test_class.new(m) }

    if defined?(Test::Unit::TestResult)
      test_result = TestUnitResult.build_test_result
      tests.each do |test|
        test.run(test_result) {}
      end
    else
      runner = MiniTest::Unit.new
      tests.each do |test|
        test.run(runner)
      end
      test_result = MiniTestResult.new(runner, tests)
    end

    test_result
  end

  def assert_passed(test_result)
    flunk "Test failed unexpectedly with message: #{test_result.failures}" if test_result.failure_count > 0
    flunk "Test failed unexpectedly with message: #{test_result.errors}" if test_result.error_count > 0
  end

  def assert_failed(test_result)
    flunk "Test passed unexpectedly" unless test_result.failure_count + test_result.error_count > 0
  end

end
