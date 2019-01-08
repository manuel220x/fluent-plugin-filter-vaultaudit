require_relative '../test_helper'

class Base64DecodeFilterTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
    keywords s3Cre7, 111222334344
    vaultaddr https://172.17.0.4:8200
    vaulttoken 111Ejjjl0S666kNNL777
  ]

  def create_driver(conf=CONFIG)
    Fluent::Test::Driver::Filter.new(Fluent::Plugin::VaultDecodeFilter).configure(conf)
  end

  test 'configure' do
    d = create_driver(CONFIG)
    assert_equal ['s3Cre7', '111222334344'], d.instance.keywords
  end

  test 'decode' do
    d = create_driver(CONFIG)
    record = {
      'type' => "request",
      'client_token' => "hmac-sha256:987b895473035ac743c70c8325aaefc42198b588d36a9b44456f6bcb67531259"
    }
    d.run(default_tag: "test") do
      d.feed(record)
    end

    filtered_records = d.filtered_records
    assert_equal(1, filtered_records.size)
    record = filtered_records[0]
    assert_equal 'request', record['type']
    assert_equal '111222334344', record['client_token']
    assert_equal false, record.has_key?('request')
  end
end
