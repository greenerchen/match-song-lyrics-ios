//
//  LyricsViewModelTests.swift
//  LyricsPiecesTests
//
//  Created by Greener Chen on 2024/9/19.
//

import XCTest
import MusixmatchAPI
@testable import LyricsPieces

final class LyricsViewModelTests: XCTestCase {

    func test_init_expectIsrcTrackArtistSet() throws {
        let sut = LyricsViewModel(song: matchedMediaItemStub)
        
        XCTAssertEqual(sut.isrc, "US25L1900253")
        XCTAssertEqual(sut.trackName, "Way Maker (Live)")
        XCTAssertEqual(sut.artistName, "Leeland")
    }
    
    func test_init_noTrackTitleAndArticst_expectIsrcTrackArtistSet() throws {
        let sut = LyricsViewModel(song: matchedMediaItemNoTitleArtistStub)
        
        XCTAssertEqual(sut.isrc, "US25L1900253")
        XCTAssertEqual(sut.trackName, "")
        XCTAssertEqual(sut.artistName, "")
    }

    func test_init_expectTrackTitleAndArtistSetup() {
        let sut = LyricsViewModel(song: matchedMediaItemStub, client: MusixmatchAPIClient())
        
        XCTAssertEqual(sut.trackName, "Way Maker (Live)")
        XCTAssertEqual(sut.artistName, "Leeland")
        XCTAssertEqual(sut.restricted, false)
        XCTAssertEqual(sut.hasLyrics, false)
    }

    func test_setUpTrack_expectTrackInfoSetup() {
        var sut = LyricsViewModel(song: matchedMediaItemStub, client: MusixmatchAPIClient())
        
        sut.setUp(track: trackStub)
        
        XCTAssertEqual(sut.trackId, 100001)
        XCTAssertEqual(sut.trackName, "Way Maker")
        XCTAssertEqual(sut.artistName, "Leeland")
        XCTAssertEqual(sut.restricted, false)
        XCTAssertEqual(sut.hasLyrics, true)
        XCTAssertEqual(sut.lyricsBody, "You are here, moving in our midst")
        XCTAssertEqual(sut.lyricsCopyright, "Copyright")
        XCTAssertEqual(sut.backlinkUrl, "link")
        XCTAssertEqual(sut.scriptTrackingUrl, nil)
    }
    
    func test_setUpLyrics_expectLyricsInfoSetup() {
        var sut = LyricsViewModel(song: matchedMediaItemStub, client: MusixmatchAPIClient())
        
        sut.setUp(lyrics: lyricsStub)
        
        XCTAssertEqual(sut.lyricsBody, "You are here, moving in our midst")
        XCTAssertEqual(sut.scriptTrackingUrl, "http://a.com")
        XCTAssertEqual(sut.lyricsCopyright, "Copyright powered by musixmatch")
    }
    
    func test_fetchTrack_byISRC_succeeded() async {
        let dataStub = trackGetResponseStringStub.data(using: .utf8)!
        let sessionMock = MusixmatchAPISessionMock(getUrlResultStub: (dataStub, responseOKStub))
        var sut = LyricsViewModel(
            song: matchedMediaItemStub,
            client: MusixmatchAPIClient(
                session: sessionMock,
                apiLimitStrategy: RequestQueuesStrategy(limitPerSecond: 2)
            )
        )
        
        await sut.fetchTrack { error in
            XCTAssertNil(error)
            
        }
    }
    
    func test_fetchTrack_byISRC_failed() async {
        let dataStub = trackSearchResponseStringStub.data(using: .utf8)!
        let sessionMock = MusixmatchAPISessionMock(getUrlResultStub: (dataStub, responseOKStub))
        var sut = LyricsViewModel(
            song: matchedMediaItemStub,
            client: MusixmatchAPIClient(
                session: sessionMock,
                apiLimitStrategy: RequestQueuesStrategy(limitPerSecond: 2)
            )
        )
        
        await sut.fetchTrack { error in
            XCTAssertNotNil(error)
            
        }
    }
    
    func test_fetchTrack_byTrackAndArtist_succeeded() async {
        let dataStub = trackSearchResponseStringStub.data(using: .utf8)!
        let sessionMock = MusixmatchAPISessionMock(getUrlResultStub: (dataStub, responseOKStub))
        var sut = LyricsViewModel(
            song: matchedMediaItemNoISRCStub,
            client: MusixmatchAPIClient(
                session: sessionMock,
                apiLimitStrategy: RequestQueuesStrategy(limitPerSecond: 2)
            )
        )
        
        await sut.fetchTrack { error in
            XCTAssertNil(error)
            
        }
    }
    
    func test_fetchTrack_byTrackAndArtist_failed() async {
        let dataStub = trackGetResponseStringStub.data(using: .utf8)!
        let sessionMock = MusixmatchAPISessionMock(getUrlResultStub: (dataStub, responseOKStub))
        var sut = LyricsViewModel(
            song: matchedMediaItemNoISRCStub,
            client: MusixmatchAPIClient(
                session: sessionMock,
                apiLimitStrategy: RequestQueuesStrategy(limitPerSecond: 2)
            )
        )
        
        await sut.fetchTrack { error in
            XCTAssertNotNil(error)
            
        }
    }
    
    func test_fetchLyrics_byISRC_succeeded() async {
        let dataStub = trackLyricsGetResponseStringStub.data(using: .utf8)!
        let sessionMock = MusixmatchAPISessionMock(getUrlResultStub: (dataStub, responseOKStub))
        var sut = LyricsViewModel(
            song: matchedMediaItemStub,
            client: MusixmatchAPIClient(
                session: sessionMock,
                apiLimitStrategy: RequestQueuesStrategy(limitPerSecond: 2)
            )
        )
        
        await sut.fetchLyrics { error in
            XCTAssertNil(error)
            
        }
    }
    
    func test_fetchLyrics_byISRC_failed() async {
        let dataStub = trackSearchResponseStringStub.data(using: .utf8)!
        let sessionMock = MusixmatchAPISessionMock(getUrlResultStub: (dataStub, responseOKStub))
        var sut = LyricsViewModel(
            song: matchedMediaItemStub,
            client: MusixmatchAPIClient(
                session: sessionMock,
                apiLimitStrategy: RequestQueuesStrategy(limitPerSecond: 2)
            )
        )
        
        await sut.fetchLyrics { error in
            XCTAssertNotNil(error)
            
        }
    }
    
    func test_fetchLyrics_byTrackAndArtist_succeeded() async {
        let dataStub = trackLyricsGetResponseStringStub.data(using: .utf8)!
        let sessionMock = MusixmatchAPISessionMock(getUrlResultStub: (dataStub, responseOKStub))
        var sut = LyricsViewModel(
            song: matchedMediaItemNoISRCStub,
            client: MusixmatchAPIClient(
                session: sessionMock,
                apiLimitStrategy: RequestQueuesStrategy(limitPerSecond: 2)
            )
        )
        sut.trackId = 1234
        
        await sut.fetchLyrics { error in
            XCTAssertNil(error)
            
        }
    }
    
    func test_fetchLyrics_byTrackAndArtist_failed() async {
        let dataStub = trackGetResponseStringStub.data(using: .utf8)!
        let sessionMock = MusixmatchAPISessionMock(getUrlResultStub: (dataStub, responseOKStub))
        var sut = LyricsViewModel(
            song: matchedMediaItemNoISRCStub,
            client: MusixmatchAPIClient(
                session: sessionMock,
                apiLimitStrategy: RequestQueuesStrategy(limitPerSecond: 2)
            )
        )
        sut.trackId = 1234
        
        await sut.fetchLyrics { error in
            XCTAssertNotNil(error)
            
        }
    }
    
    func test_getMessage_hasLyricsIrrestricted() {
        var sut = LyricsViewModel(song: matchedMediaItemStub)
        sut.setUp(track: trackStub)
        sut.setUp(lyrics: lyricsStub)
        
        XCTAssertTrue(sut.hasLyrics)
        XCTAssertFalse(sut.restricted)
        
        let msg = sut.getMessage()
        
        XCTAssertTrue(msg.contains("Way Maker")) // track name
        XCTAssertTrue(msg.contains("Leeland")) // artist
        XCTAssertTrue(msg.contains("You are here, moving in our midst")) // lyrics body
        XCTAssertTrue(msg.contains(sut.scriptTrackingUrl!))
        XCTAssertTrue(msg.contains(sut.lyricsCopyright!))
        XCTAssertTrue(msg.contains(sut.backlinkUrl!))
    }
    
    func test_getMessage_hasLyricsIrrestricted_lackPartialTrackInfo() {
        var sut = LyricsViewModel(song: matchedMediaItemStub)
        sut.setUp(track: trackStub)
        sut.setUp(lyrics: lyricsStub)
        sut.lyricsBody! += "\n"
        sut.scriptTrackingUrl = nil
        sut.lyricsCopyright = nil
        sut.backlinkUrl = nil
        
        XCTAssertTrue(sut.hasLyrics)
        XCTAssertFalse(sut.restricted)
        
        let msg = sut.getMessage()
        
        XCTAssertTrue(msg.contains("Way Maker")) // track name
        XCTAssertTrue(msg.contains("Leeland")) // artist
        XCTAssertTrue(msg.contains("You are here, moving in our midst<br/>")) // lyrics body
    }
    
    func test_getMessage_hasLyricsRestricted() {
        var sut = LyricsViewModel(song: matchedMediaItemStub)
        sut.hasLyrics = true
        sut.restricted = true
        
        let msg = sut.getMessage()
        
        XCTAssertEqual(msg, "Lyrics Restricted in your country")
    }
    
    func test_getMessage_hasError() {
        var sut = LyricsViewModel(song: matchedMediaItemStub)
        sut.error = MusixmatchAPIClient.Error.exceedAPIRateLimit
        
        let msg = sut.getMessage()
        
        XCTAssertEqual(msg, "Ooops. Something wrong. Please try again later.")
    }
    
    func test_getMessage_hasNoLyricsBody() {
        var sut = LyricsViewModel(song: matchedMediaItemStub)
        sut.lyricsBody = nil
        
        let msg = sut.getMessage()
        
        XCTAssertEqual(msg, "Lyrics Not Found")
    }
    
    func test_makeHTMLString_hasNoLyricsBody() {
        var sut = LyricsViewModel(song: matchedMediaItemStub)
        sut.lyricsBody = nil
        
        let msg = sut.makeHtmlString()
        
        XCTAssertEqual(msg, "")
    }
}
