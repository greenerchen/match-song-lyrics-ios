# match-song-lyrics-ios
A side project to learn SwiftUI and maintain time management discipline

# Project Timeline
![Timeline of Sprint 1](timeline-sprint1.png)

# Feature Specs
## Story: Shazam song and get lyrics 
### Narrative #1
```
As an online user listening to a song recording in a cafe
I want the app to find the song and its lyrics
So I can sing along with the music in the air
```
### Scenarios (Acceptance criteria)
```
Given the user has connectivity and a song recording in the air
When the user taps the button to shazam song
Then the app should display the matched song and a button to display lyrics
```
### Narrative #2
```
As an offline user listening to a song recording in a cafe
I want the app to display no internet
So I can know I should've be online
```
### Scenarios (Acceptance criteria)
```
Given the user has no connectivity
When the user taps the button to shazam song
Then the app should display an error message of no connectivity
```

# Use Cases
## Shazam song Use Case
### Data
- A popular song recording is playing
### Primary Course (happy path):
1. Tap the logo to shazam
2. ShazamKit is working to match song
3. ShazamKit has matched a song
4. The app display the matched song
### Invalid Data - Error Course (sad path):
1. No song recordings is playing or a person sings a song 
2. The app displays no song matched
### No Connectivity - Error Course (sad path):
1. The app displays no connectivity error

## Get Lyrics Use Case
### Data
- The artist and song title 
### Primary Course (happy path):
1. The app queries lyrics
2. The app downloads lyrics
3. The app creats a Song from valid data
4. The app displays the lyrics
### Invalid Data - Error Course (sad path):
1. The app displays no lyrics found
### No Connectivity - Error Course (sad path):
1. The app displays no connectivity error

# Flowchart
[TBA]

# Model Specs
## Song
| Property | Type |
|-------|------|
| title | String |
| url | URL |
| artistNames | String |

## Payload Contract - Musixmatch Lyrics API
### Authentication
```
Parameters:
- `apiKey`: Your personal api key, you must use it in every API call. You can pass this parameter as `GET` parameter in your api call, like `track.get?apiKey=xxx`
```

### track.search
Search for track in musixmatch's database
```
GET track.search

Parameters:
- `q_track`: the song title
- `q_artist`: the song artist

200 RESPONSE

{
    "message": {
        "header": {
            "status_code": 200,
            ...
        },
        "body": {
            "track_list": [
                {
                    "track_id": 170323904,
                    "commontrack_id": 93911869,
                    "restricted": 0,
                    "explicit": 0,
                    "has_lyrics": 1,
                    "has_subtitles": 1,
                    "lyrics_id": 35772235,
                    "subtitle_id": 3532383,
                    "lyrics_copyright": "Lyrics powered by www.musixmatch.com",
                    ...
                },
                ...
            ]
        }
    }
}
```

### track.lyrics.get
Get the lyrics for a track. Make sure fulfill `country restriction` you receive within every copyrighted content.
```
GET track.lyrics.get

Parameters:
- `commontrack_id`: the musixmatch commontrack id
- `track_isrc`: A valid ISRC identifier

200 RESPONSE

{
    "message": {
        "header": {
            "status_code": 200,
            ...
        },
        "body": {
            "lyrics": {
                "lyrics_id": 23904,
                "restricted": 0,
                "explicit": 0,
                "lyrics_body": "I know I know ....",
                "pixel_tracking_url": "https://tracking.musixmatch.com/t1.0/AMz6ed8EFA90DEsE",
                "lyrics_copyright": "Lyrics powered by www.musixmatch.com",
                "backlink_url": "https://www.musixmatch.com/lyrics/Lady-Gaga/.....",
                ...
            }
        }
    }
}

```

### track.subtitle.get
Get the subtitle for a track. Make sure to:
- fulfill the `country restriction` you receive within every copyrighted content
- apply the `tracking method` of your choice

```
GET track.subtitle.get

Parameters:
- `commontrack_id`: the musixmatch commontrack id
- `subtitle_format`: the format of the subtitle (lrc, dfxp, stledu). Default to lrc
- `f_subtitle_length`: the desired length of the subtitle (seconds)
- `f_subtitle_length_max_deviation`: the maximum deviation allowed from the f_subtitle_length (seconds)

GET track.subtitle.get?commontrack_id=10074988

200 RESPONSE

{
    "message": {
        "header": {
            "status_code": 200,
            ...
        },
        "body": {
            "subtitle": {
                "subtitle_id": 18117,
                "restricted": 0,
                "subtitle_body": "[00:20:51] Heart beats fast ...",
                "pixel_tracking_url": "https://tracking.musixmatch.com/t1.0/AMz6ed8EFA90DEsE",
                "lyrics_copyright": "Lyrics powered by www.musixmatch.com"
            }
        }
    }
}
```

# App Architecture
[TBA]
