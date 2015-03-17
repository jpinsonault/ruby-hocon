require 'spec_helper'
require 'hocon'
require 'test_utils'


SimpleConfigOrigin = Hocon::Impl::SimpleConfigOrigin
SimpleConfigObject = Hocon::Impl::SimpleConfigObject
SimpleConfigList = Hocon::Impl::SimpleConfigList
SubstitutionExpression = Hocon::Impl::SubstitutionExpression
ConfigReference = Hocon::Impl::ConfigReference

describe "SimpleConfigOrigin equality" do
  context "different origins with the same name should be equal" do
    let(:a) { SimpleConfigOrigin.new_simple("foo") }
    let(:same_as_a) { SimpleConfigOrigin.new_simple("foo") }
    let(:b) { SimpleConfigOrigin.new_simple("bar") }

    context "a equals a" do
      let(:first_object) { a }
      let(:second_object) { a }
      include_examples "object_equality"
    end

    context "a equals same_as_a" do
      let(:first_object) { a }
      let(:second_object) { same_as_a }
      include_examples "object_equality"
    end

    context "a does not equal b" do
      let(:first_object) { a }
      let(:second_object) { b }
      include_examples "object_inequality"
    end
  end
end

describe "ConfigInt equality" do
  context "different ConfigInts with the same value should be equal" do
    a = TestUtils.int_value(42)
    same_as_a = TestUtils.int_value(42)
    b = TestUtils.int_value(43)

    context "a equals a" do
      let(:first_object) { a }
      let(:second_object) { a }
      include_examples "object_equality"
    end

    context "a equals same_as_a" do
      let(:first_object) { a }
      let(:second_object) { same_as_a }
      include_examples "object_equality"
    end

    context "a does not equal b" do
      let(:first_object) { a }
      let(:second_object) { b }
      include_examples "object_inequality"
    end
  end
end

describe "ConfigFloat equality" do
  context "different ConfigInts with the same value should be equal" do
    a = TestUtils.float_value(42)
    same_as_a = TestUtils.float_value(42)
    b = TestUtils.float_value(43)

    context "a equals a" do
      let(:first_object) { a }
      let(:second_object) { a }
      include_examples "object_equality"
    end

    context "a equals same_as_a" do
      let(:first_object) { a }
      let(:second_object) { same_as_a }
      include_examples "object_equality"
    end

    context "a does not equal b" do
      let(:first_object) { a }
      let(:second_object) { b }
      include_examples "object_inequality"
    end
  end
end

describe "ConfigFloat and ConfigInt equality" do
  context "different ConfigInts with the same value should be equal" do
    float_val = TestUtils.float_value(3.0)
    int_value = TestUtils.int_value(3)
    float_value_b = TestUtils.float_value(4.0)
    int_value_b = TestUtils.float_value(4)

    context "int equals float" do
      let(:first_object) { float_val }
      let(:second_object) { int_value }
      include_examples "object_equality"
    end

    context "ConfigFloat made from int equals float" do
      let(:first_object) { float_value_b }
      let(:second_object) { int_value_b }
      include_examples "object_equality"
    end

    context "3 doesn't equal 4.0" do
      let(:first_object) { int_value }
      let(:second_object) { float_value_b }
      include_examples "object_inequality"
    end

    context "4.0 doesn't equal 3.0" do
      let(:first_object) { int_value_b }
      let(:second_object) { float_val }
      include_examples "object_inequality"
    end
  end
end

describe "SimpleConfigObject equality" do
  context "SimpleConfigObjects made from hash maps" do
    a_map = TestUtils.config_map({a: 1, b: 2, c: 3})
    same_as_a_map = TestUtils.config_map({a: 1, b: 2, c: 3})
    b_map = TestUtils.config_map({a: 3, b: 4, c: 5})

    # different keys is a different case in the equals implementation
    c_map = TestUtils.config_map({x: 3, y: 4, z: 5})

    a = SimpleConfigObject.new(TestUtils.fake_origin, a_map)
    same_as_a = SimpleConfigObject.new(TestUtils.fake_origin, same_as_a_map)
    b = SimpleConfigObject.new(TestUtils.fake_origin, b_map)
    c = SimpleConfigObject.new(TestUtils.fake_origin, c_map)

    # the config for an equal object is also equal
    config = a.to_config

    context "a equals a" do
      let(:first_object) { a }
      let(:second_object) { a }
      include_examples "object_equality"
    end

    context "a equals same_as_a" do
      let(:first_object) { a }
      let(:second_object) { same_as_a }
      include_examples "object_equality"
    end

    context "b equals b" do
      let(:first_object) { b }
      let(:second_object) { b }
      include_examples "object_equality"
    end

    context "c equals c" do
      let(:first_object) { c }
      let(:second_object) { c }
      include_examples "object_equality"
    end

    context "a doesn't equal b" do
      let(:first_object) { a }
      let(:second_object) { b }
      include_examples "object_inequality"
    end

    context "a doesn't equal c" do
      let(:first_object) { a }
      let(:second_object) { c }
      include_examples "object_inequality"
    end

    context "b doesn't equal c" do
      let(:first_object) { b }
      let(:second_object) { c }
      include_examples "object_inequality"
    end

    context "a's config equals a's config" do
      let(:first_object) { config }
      let(:second_object) { config }
      include_examples "object_equality"
    end

    context "a's config equals same_as_a's config" do
      let(:first_object) { config }
      let(:second_object) { same_as_a.to_config }
      include_examples "object_equality"
    end

    context "a's config equals a's config computed again" do
      let(:first_object) { config }
      let(:second_object) { a.to_config }
      include_examples "object_equality"
    end

    context "a's config doesn't equal b's config" do
      let(:first_object) { config }
      let(:second_object) { b.to_config }
      include_examples "object_inequality"
    end

    context "a's config doesn't equal c's config" do
      let(:first_object) { config }
      let(:second_object) { c.to_config }
      include_examples "object_inequality"
    end

    context "a doesn't equal a's config" do
      let(:first_object) { a }
      let(:second_object) { config }
      include_examples "object_inequality"
    end

    context "b doesn't equal b's config" do
      let(:first_object) { b }
      let(:second_object) { b.to_config }
      include_examples "object_inequality"
    end
  end
end

describe "SimpleConfigList equality" do
  a_values = [1, 2, 3].map { |i| TestUtils.int_value(i) }
  a_list = SimpleConfigList.new(TestUtils.fake_origin, a_values)

  same_as_a_values = [1, 2, 3].map { |i| TestUtils.int_value(i) }
  same_as_a_list = SimpleConfigList.new(TestUtils.fake_origin, same_as_a_values)

  b_values = [4, 5, 6].map { |i| TestUtils.int_value(i) }
  b_list = SimpleConfigList.new(TestUtils.fake_origin, b_values)

  context "a_list equals a_list" do
    let(:first_object) { a_list }
    let(:second_object) { a_list }
    include_examples "object_equality"
  end

  context "a_list equals same_as_a_list" do
    let(:first_object) { a_list }
    let(:second_object) { same_as_a_list }
    include_examples "object_equality"
  end

  context "a_list doesn't equal b_list" do
    let(:first_object) { a_list }
    let(:second_object) { b_list }
    include_examples "object_inequality"
  end
end

describe "ConfigReference equality" do
  a = TestUtils.subst("foo")
  same_as_a = TestUtils.subst("foo")
  b = TestUtils.subst("bar")
  c = TestUtils.subst("foo", true)

  specify "testing values are of the right type" do
    expect(a).to be_instance_of(ConfigReference)
    expect(b).to be_instance_of(ConfigReference)
    expect(c).to be_instance_of(ConfigReference)
  end

  context "a equals a" do
    let(:first_object) { a }
    let(:second_object) { a }
    include_examples "object_equality"
  end

  context "a equals same_as_a" do
    let(:first_object) { a }
    let(:second_object) { same_as_a }
    include_examples "object_equality"
  end

  context "a doesn't equal b" do
    let(:first_object) { a }
    let(:second_object) { b }
    include_examples "object_inequality"
  end

  context "a doesn't equal c, an optional substitution" do
    let(:first_object) { a }
    let(:second_object) { c }
    include_examples "object_inequality"
  end
end

describe "ConfigConcatenation equality" do
  a = TestUtils.subst_in_string("foo")
  same_as_a = TestUtils.subst_in_string("foo")
  b = TestUtils.subst_in_string("bar")
  c = TestUtils.subst_in_string("foo", true)

  specify "testing values are of the right type" do
    expect(a).to be_instance_of(ConfigReference)
    expect(b).to be_instance_of(ConfigReference)
    expect(c).to be_instance_of(ConfigReference)
  end

  context "a equals a" do
    let(:first_object) { a }
    let(:second_object) { a }
    include_examples "object_equality"
  end

  context "a equals same_as_a" do
    let(:first_object) { a }
    let(:second_object) { same_as_a }
    include_examples "object_equality"
  end

  context "a doesn't equal b" do
    let(:first_object) { a }
    let(:second_object) { b }
    include_examples "object_inequality"
  end

  context "a doesn't equal c, an optional substitution" do
    let(:first_object) { a }
    let(:second_object) { c }
    include_examples "object_inequality"
  end
end
