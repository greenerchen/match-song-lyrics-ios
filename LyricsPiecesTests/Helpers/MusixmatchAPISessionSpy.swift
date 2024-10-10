//
//  MusixmatchAPISessionMock.swift
//  LyricsPiecesTests
//
//  Created by Greener Chen on 2024/9/19.
//

import Foundation
import MusixmatchAPI

final class MusixmatchAPISessionSpy: URLSessionProtocol {
    
    static var trackGetOKSession: MusixmatchAPISessionSpy = MusixmatchAPISessionSpy(getUrlResultStub: (Data(trackGetResponseStringStub.utf8), responseOKStub))
    
    static var trackSearchOKSession: MusixmatchAPISessionSpy = MusixmatchAPISessionSpy(getUrlResultStub: (Data(trackSearchResponseStringStub.utf8), responseOKStub))
    
    static var trackSearchNotFoundSession: MusixmatchAPISessionSpy = MusixmatchAPISessionSpy(getUrlResultStub: (Data(trackSearchNoTrackResponseStringStub.utf8), responseOKStub))
    
    var getUrlCallCount: Int = 0
    
    var getUrlResultStub: (data: Data, response: URLResponse)
    
    init(getUrlResultStub: (data: Data, response: URLResponse)) {
        self.getUrlResultStub = getUrlResultStub
    }
    
    func get(_ url: URL) async throws -> (data: Data, response: URLResponse) {
        getUrlCallCount += 1
        return getUrlResultStub
    }
}

