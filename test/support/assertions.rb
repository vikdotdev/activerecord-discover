module Minitest::Assertions

  # Borrowed from which library?
  def assert_same_elements(a1, a2, msg = nil)
    [:select, :inject, :size].each do |m|
      [a1, a2].each {|a| assert_respond_to(a, m, "Are you sure that #{a.inspect} is an array?  It doesn't respond to #{m}.") }
    end

    assert a1h = a1.inject({}) { |h,e| h[e] ||= a1.select { |i| i == e }.size; h }
    assert a2h = a2.inject({}) { |h,e| h[e] ||= a2.select { |i| i == e }.size; h }

    assert_equal(a1h, a2h, msg)
  end

  def assert_all_equal(collection, value, msg=nil)
    msg = message(msg, "") {
      "Expected #{mu_pp(collection)} to contain only #{mu_pp(true)} values"
    }
    assert collection.all? {|item| item == value} == true, msg
  end

  def refute_all_equal(collection, value, message=nil)
    msg = message(msg, "") {
      "Expected #{mu_pp(collection)} not to only contain #{mu_pp(true)} values"
    }
    assert collection.all? {|item| item == value} == false, msg
  end
end
