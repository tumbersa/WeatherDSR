import Foundation

// MARK: - ForecastModel
struct ForecastModel: Codable {
    let location: Location
    let current: Current?
    let forecast: Forecast
    
    // MARK: - Current
    struct Current: Codable {
        let lastUpdatedEpoch: Double?
        let lastUpdated: String?
        let tempC, tempF: Double
        let isDay: Int
        let condition: Condition?
        let windMph, windKph: Double
        let windDegree: Double
        let windDir: WindDir
        let pressureMB: Double
        let pressureIn, precipMm: Double
        let precipIn, humidity, cloud: Double
        let feelslikeC, feelslikeF, windchillC, windchillF: Double
        let heatindexC, heatindexF, dewpointC, dewpointF: Double
        let visKM, visMiles, uv: Double
        let gustMph, gustKph: Double
        let timeEpoch: Double?
        let time: String?
        let snowCM, willItRain, chanceOfRain, willItSnow: Double?
        let chanceOfSnow: Double?
        
        enum CodingKeys: String, CodingKey {
            case lastUpdatedEpoch = "last_updated_epoch"
            case lastUpdated = "last_updated"
            case tempC = "temp_c"
            case tempF = "temp_f"
            case isDay = "is_day"
            case condition
            case windMph = "wind_mph"
            case windKph = "wind_kph"
            case windDegree = "wind_degree"
            case windDir = "wind_dir"
            case pressureMB = "pressure_mb"
            case pressureIn = "pressure_in"
            case precipMm = "precip_mm"
            case precipIn = "precip_in"
            case humidity, cloud
            case feelslikeC = "feelslike_c"
            case feelslikeF = "feelslike_f"
            case windchillC = "windchill_c"
            case windchillF = "windchill_f"
            case heatindexC = "heatindex_c"
            case heatindexF = "heatindex_f"
            case dewpointC = "dewpoint_c"
            case dewpointF = "dewpoint_f"
            case visKM = "vis_km"
            case visMiles = "vis_miles"
            case uv
            case gustMph = "gust_mph"
            case gustKph = "gust_kph"
            case timeEpoch = "time_epoch"
            case time
            case snowCM = "snow_cm"
            case willItRain = "will_it_rain"
            case chanceOfRain = "chance_of_rain"
            case willItSnow = "will_it_snow"
            case chanceOfSnow = "chance_of_snow"
        }
    }
    
    // MARK: - Condition
    struct Condition: Codable {
        let text: Text?
        let icon: String
        let code: Int
    }
    
    enum Text: String, Codable {
        case clear = "Clear"
        case cloudy = "Cloudy"
        case overcast = "Overcast"
        case partlyCloudy = "Partly Cloudy"
        case patchyRainNearby = "Patchy rain nearby"
        case sunny = "Sunny"
        case mist = "Mist"
        case unknown = "Unknown" // Default case

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(String.self).trimmingCharacters(in: .whitespaces)
            self = Text(rawValue: rawValue) ?? .unknown
        }
    }
    
    enum WindDir: String, Codable {
        case n = "N"
        case nne = "NNE"
        case ne = "NE"
        case ene = "ENE"
        case e = "E"
        case ese = "ESE"
        case se = "SE"
        case sse = "SSE"
        case s = "S"
        case ssw = "SSW"
        case sw = "SW"
        case wsw = "WSW"
        case w = "W"
        case wnw = "WNW"
        case nw = "NW"
        case nnw = "NNW"
    }
    
    // MARK: - Forecast
    struct Forecast: Codable {
        let forecastday: [Forecastday]
    }
    
    // MARK: - Forecastday
    struct Forecastday: Codable {
        let date: String
        let dateEpoch: Double
        let day: Day
        let astro: Astro
        let hour: [Current]
        
        enum CodingKeys: String, CodingKey {
            case date
            case dateEpoch = "date_epoch"
            case day, astro, hour
        }
    }
    
    // MARK: - Astro
    struct Astro: Codable {
        let sunrise, sunset, moonrise, moonset: String
        let moonPhase: String
        let moonIllumination, isMoonUp, isSunUp: Int
        
        enum CodingKeys: String, CodingKey {
            case sunrise, sunset, moonrise, moonset
            case moonPhase = "moon_phase"
            case moonIllumination = "moon_illumination"
            case isMoonUp = "is_moon_up"
            case isSunUp = "is_sun_up"
        }
    }
    
    // MARK: - Day
    struct Day: Codable {
        let maxtempC, maxtempF, mintempC, mintempF: Double
        let avgtempC, avgtempF, maxwindMph, maxwindKph: Double
        let totalprecipMm: Double
        let totalprecipIn, totalsnowCM, avgvisKM, avgvisMiles: Double
        let avghumidity, dailyWillItRain, dailyChanceOfRain, dailyWillItSnow: Double
        let dailyChanceOfSnow: Double
        let condition: Condition?
        let uv: Double
        
        enum CodingKeys: String, CodingKey {
            case maxtempC = "maxtemp_c"
            case maxtempF = "maxtemp_f"
            case mintempC = "mintemp_c"
            case mintempF = "mintemp_f"
            case avgtempC = "avgtemp_c"
            case avgtempF = "avgtemp_f"
            case maxwindMph = "maxwind_mph"
            case maxwindKph = "maxwind_kph"
            case totalprecipMm = "totalprecip_mm"
            case totalprecipIn = "totalprecip_in"
            case totalsnowCM = "totalsnow_cm"
            case avgvisKM = "avgvis_km"
            case avgvisMiles = "avgvis_miles"
            case avghumidity
            case dailyWillItRain = "daily_will_it_rain"
            case dailyChanceOfRain = "daily_chance_of_rain"
            case dailyWillItSnow = "daily_will_it_snow"
            case dailyChanceOfSnow = "daily_chance_of_snow"
            case condition, uv
        }
    }
    
    // MARK: - Location
    struct Location: Codable {
        let name, region, country: String
        let lat, lon: Double
        let tzID: String
        let localtimeEpoch: Int
        let localtime: String
        
        enum CodingKeys: String, CodingKey {
            case name, region, country, lat, lon
            case tzID = "tz_id"
            case localtimeEpoch = "localtime_epoch"
            case localtime
        }
    }
}

