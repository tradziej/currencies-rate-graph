module Fixer
  class Feed
   private
    def url
      URI("https://www.ecb.europa.eu/stats/eurofxref/eurofxref-#{@scope}.xml")
    end
  end
end