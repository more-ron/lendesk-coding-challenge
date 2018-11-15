require 'test_helper'
require 'csv'

class GpsProcessorTest < Test::Unit::TestCase

  def setup
  end

  def teardown
    FileUtils.rm './tmp/gps.csv', force: true
    FileUtils.rm './tmp/gps.html', force: true
  end

  def test_csv
    ExtractExif::GpsProcessor.process path: './images',
                                      output_filepath: './tmp/gps.csv'

    assert_equal File.read('./test/expected/gps.csv'), File.read('./tmp/gps.csv')
  end

  def test_html
    ExtractExif::GpsProcessor.process path: './images',
                                      output_filepath: './tmp/gps.html'

    assert_equal File.read('./test/expected/gps.html'), File.read('./tmp/gps.html')
  end
end
