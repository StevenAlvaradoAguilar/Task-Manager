# lib/tasks/fetch_sismic_data.rake

require 'open-uri'

namespace :fetch_sismic_data do
  task :execute => :environment do
    url = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson'
    response = JSON.parse(URI.open(url).read)

    response['features'].each do |feature|
      next unless valid_feature?(feature)

      Feature.find_or_create_by(external_id: feature['id']) do |f|
        f.magnitude = feature['properties']['mag']
        f.place = feature['properties']['place']
        f.time = Time.at(feature['properties']['time'] / 1000)
        f.url = feature['properties']['url']
        f.tsunami = feature['properties']['tsunami']
        f.mag_type = feature['properties']['magType']
        f.title = feature['properties']['title']
        f.longitude, f.latitude = feature['geometry']['coordinates']
      end
    end
  end

  def valid_feature?(feature)
    feature['properties']['title'].present? &&
      feature['properties']['url'].present? &&
      feature['properties']['place'].present? &&
      feature['properties']['magType'].present? &&
      feature['geometry']['coordinates'][0].between?(-180.0, 180.0) &&
      feature['geometry']['coordinates'][1].between?(-90.0, 90.0) &&
      feature['properties']['mag'].between?(-1.0, 10.0)
  end
end
