//
// Copyright 2023 Signal Messenger, LLC
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation

struct OsExpiry {
    static var `default`: OsExpiry {
        return OsExpiry(
            minimumIosMajorVersion: 1,
            enforcedAfter: .distantFuture,
        )
    }

    let minimumIosMajorVersion: Int
    let enforcedAfter: Date
}
