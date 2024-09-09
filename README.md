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

## Payload Contract - Genius Lyrics API
```
Header
Authorization: Bearer <Access Token>

GET https://api.genius.com/search?q=keyword

200 RESPONSE

{
    meta: {
        status: 200
    },
    response: {
        hits: [
            {
                highlights: [...],
                index: "song",
                type: "song",
                result: {
                    artist_names: "Kendrick Lamar",
                    title: "HUMBLE.",
                    url: "https://genius.com/Kendrick-lamar-humble-lyrics",
                    ...
                }
            },
            {...},
            {...}
        ]
    }
}

```
# App Architecture
[TBA]
