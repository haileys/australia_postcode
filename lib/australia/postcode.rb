# coding: utf-8
require "csv"
require "australia/postcode/version"

# A module for all things Australian
module Australia
  # The Australia::Postcode class represents Australian postcodes and provides
  # methods for manipulating them. Right now you can find the distance between
  # two postcodes and that's about it.
  class Postcode
    attr_reader :postcode, :suburb, :state, :delivery_center, :type, :latitude, :longitude

    def initialize(postcode, suburb, state, delivery_center, type, latitude, longitude)
      @postcode         = postcode.to_i
      @suburb           = suburb.strip
      @state            = state.strip
      @delivery_center  = delivery_center.strip
      @type             = type.strip
      @latitude         = latitude.to_f
      @longitude        = longitude.to_f
    end

    # Returns a [latitude, longitude] tuple
    #
    # @return [Array]
    def coords
      [latitude, longitude]
    end

    # Computes the distance from this postcode to another postcode using the
    # Haversine formula
    #
    # @return [Float]
    def distance(other)
      earth_radius = 6371
      Δlat = radians(other.latitude - latitude)
      Δlong = radians(other.longitude - longitude)
      a = sin(Δlat / 2) * sin(Δlat / 2) +
          cos(radians(latitude)) * cos(radians(other.latitude)) *
          sin(Δlong / 2) * sin(Δlong / 2)
      c = 2 * atan2(√(a), √(1 - a))
      earth_radius * c
    end

    alias_method :-, :distance

    # Inspects the [Postcode]
    def inspect
      "#<#{self.class} postcode=#{postcode.inspect} suburb=#{suburb.inspect} latitude=#{latitude.inspect} longitude=#{longitude.inspect}>"
    end

  private

    def sin(θ)
      Math.sin θ
    end

    def cos(θ)
      Math.cos θ
    end

    def atan2(y, x)
      Math.atan2 y, x
    end

    def √(x)
      Math.sqrt x
    end

    def radians(degrees)
      degrees * π / 180
    end

    def π
      Math::PI
    end

    class << self
      # Finds all postcodes/suburbs for the given postcode.
      #
      # @return [Array[Postcode]]
      def find(postcode)
        indexed_on_postcode[postcode.to_i]
      end

      # Finds all the postcodes/suburbs for the given suburb name.
      #
      # @return [Array[Postcode]]
      def find_by_suburb(suburb)
        indexed_on_suburb[suburb.strip.upcase]
      end

      # Finds the closest postcode to the given coordinates
      #
      # @return [Postcode]
      def find_by_coords(latitude, longitude)
        data.min_by { |postcode|
          (latitude - postcode.latitude) ** 2 + (longitude - postcode.longitude) ** 2
        }
      end

    private
      def indexed_on_postcode
        @indexed_on_postcode ||= data.group_by(&:postcode)
      end

      def indexed_on_suburb
        @indexed_on_suburb ||= data.group_by(&:suburb)
      end

      def data
        @data ||= raw_data.map { |data| new(*data) }.select { |postcode| postcode.type == "Delivery Area" }
      end

      def raw_data
        CSV.parse(File.read(data_filename)).drop(1)
      end

      def data_filename
        File.expand_path("../postcode/data.csv", __FILE__)
      end
    end
  end
end
