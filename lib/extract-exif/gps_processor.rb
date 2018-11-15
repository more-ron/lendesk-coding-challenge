require 'csv'
require 'slim'
require 'exif'

module ExtractExif
  class GpsProcessor
    class << self
      def process(path:, output_filepath:)
        new(path: path, output_filepath: output_filepath).process
      end
    end

    def initialize(path:, output_filepath:)
      @path = path
      @output_filepath = output_filepath
    end

    def process
      Dir["#{path}/**/*.{jpg,jpeg}"].each do |image_path|
        rows << process_image(image_path)
      end


      case output_file_format
      when '.csv'
        generate_csv
      when '.html'
        generate_html
      else
        raise ArgumentError, "unsupported output format: #{output_file_format}"
      end
    end

    def headers
      [
        'Image Path',
        'Latitude',
        'Longitude',
        'Map Link',
        'Note'
      ]
    end

    def rows
      @rows ||= []
    end

    private

    attr_reader :path, :output_filepath

    def output_file_format
      @output_file_format ||= File.extname(output_filepath)
    end

    def generate_csv
      CSV.open(output_filepath, 'w', write_headers: true, headers: headers) do |csv|
        rows.each do |row|
          csv << [
            row[:image_path],
            row[:latitude],
            row[:longitude],
            row[:map_link],
            row[:note]
          ]
        end
      end
    end

    def generate_html
      File.write output_filepath, Slim::Template.new("#{__dir__}/gps_template.slim").render(self)
    end

    # @param [String] image_path
    # @return [Array]
    def process_image(image_path)
      data = Exif::Data.new(File.open(image_path))

      gps_data = data[:gps]

      if gps_data.empty?
        {
          image_path: image_path,
          latitude: '?',
          longitude: '?',
          map_link: '?',
          note: 'No GPS data found'
        }
      else
        {
          image_path: image_path,
          latitude: display_degrees(gps_data[:gps_latitude], ref: gps_data[:gps_latitude_ref]),
          longitude: display_degrees(gps_data[:gps_longitude], ref: gps_data[:gps_longitude_ref]),
          map_link: map_link(gps_data),
          note: nil
        }
      end
    rescue => exception
      {
        image_path: image_path,
        latitude: '?',
        longitude: '?',
        map_link: '?',
        note: exception.message
      }
    end

    # @param [Array<Fixnum>] parts - [degrees, minutes, seconds]
    # @param [String] ref - direction
    def display_degrees(parts, ref:)
      "#{parts[0].to_i}°#{parts[1].to_i}'#{parts[2].to_i}\" #{ref}"
    end

    # @param [Hash] gps
    # @return [String]
    def map_link(gps)
      gps[:gps_latitude_ref]
      gps[:gps_latitude]
      gps[:gps_longitude_ref]
      gps[:gps_longitude]

      lat = degrees_to_decimal(gps[:gps_latitude])
      lat *= -1.0 if gps[:gps_latitude_ref] == 'S'
      lon = degrees_to_decimal(gps[:gps_longitude])
      lon *= -1.0 if gps[:gps_longitude_ref] == 'W'

      "https://www.google.pl/maps/@#{lat},#{lon},13z"
    end

    def degrees_to_decimal(parts)
      value = parts[0].to_f # degrees
      value += parts[1].to_f / 60.0 # minutes
      value += parts[2].to_f / 3600.0 # seconds
      value
    end
  end
end
