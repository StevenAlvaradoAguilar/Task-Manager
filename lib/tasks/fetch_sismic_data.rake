require 'open-uri'

namespace :fetch_sismic_data do
    task :execute => :environment do
        url = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson'
        response = JSON.parse(URI.open(url).read)

        response['features'].each do |feature|
          next unless valid_feature?(feature)

          external_id = feature['id']

          # Verificar si ya existe un registro con el mismo id
          existing_feature = Feature.find_by(external_id: external_id)

          unless existing_feature
            # Si no existe, crear un nuevo registro
            Feature.create!(extract_feature_data(feature))
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

    def extract_feature_data(feature)
      # Extraer y retornar los datos de la característica para crear un nuevo registro
      Feature.find_or_create_by(external_id: feature['id']) do |data|
        data.magnitude = feature['properties']['mag']
        data.place = feature['properties']['place']
        data.time = Time.at(feature['properties']['time'] / 1000)
        data.url = feature['properties']['url']
        data.tsunami = feature['properties']['tsunami']
        data.mag_type = feature['properties']['magType']
        data.title = feature['properties']['title']
        data.longitude, data.latitude = feature['geometry']['coordinates']
      end
    end
end
