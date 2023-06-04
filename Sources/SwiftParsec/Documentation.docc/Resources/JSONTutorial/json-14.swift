// Example JSON text
let jsonText = """
{
    "Image": {
        "Width":  800,
        "Height": 600,
        "Title":  "View from 15th Floor",
        "Thumbnail": {
            "Url":    "http://www.example.com/image/481989943",
            "Height": 125,
            "Width":  "100"
        },
        "IDs": [116, 943, 234, 38793]
    }
}
"""

do {
    // Parse the JSON text
    let json = try JSONValue(data: jsonText)

    // Access individual values
    if let thumbnailHeight = json["Image"]["Thumbnail"]["Height"].double {
        print(thumbnailHeight)
    }
} catch {
    print("Error parsing JSON: \(error)")
}
