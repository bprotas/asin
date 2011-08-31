require 'hashie'
require 'date'

module ASIN

  # =SimpleItem
  #
  # The +SimpleItem+ class is a wrapper for the Amazon XML-REST-Response.
  #
  # A Hashie::Mash is used for the internal data representation and can be accessed over the +raw+ attribute.
  #
  class SimpleItem

    attr_reader :raw

    def initialize(hash)
      @raw = Hashie::Mash.new(hash)
    end

    def asin
      @raw.ASIN
    end

    def amount
      self.list_price.Amount.to_i
    end

    def details_url
      @raw.DetailPageURL
    end

    def review
       @raw.EditorialReviews!.EditorialReview!.Content
    end

    def image_url
      @raw.LargeImage!.URL
    end

    def parse_date(d)
      Date.parse(d)
    end

    def method_missing(meth, *args)
      # ItemAttributes only deals with camel-cased names, but we want to 
      # accept "rubyfied" (snake_case) names as well:
      normalized_meth = meth.to_s.camelize

      # If we're dealing with something like "_date" when camalized
      # and we have the attribute, parse the date; if we can't parse it, 
      # throw a meaningful exception:
      if normalized_meth =~ /.+_date$/ && @raw.ItemAttributes!.respond_to?(normalized_meth) then
        self.parse_date(@raw.ItemAttributes!.send(normalized_meth))
      elsif @raw.ItemAttributes!.respond_to?(normalized_meth)
        @raw.ItemAttributes!.send(normalized_meth)
      else
        super
      end
    end

    def respond_to?(name)
      !!(@raw.ItemAttributes!.respond_to?(name.to_s.camelize) || super)
    end

    def attributes
      @raw.ItemAttributes!.keys
    end
  end
end
