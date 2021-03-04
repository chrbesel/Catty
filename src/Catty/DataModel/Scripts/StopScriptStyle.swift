/**
 *  Copyright (C) 2010-2021 The Catrobat Team
 *  (http://developer.catrobat.org/credits)
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  An additional term exception under section 7 of the GNU Affero
 *  General Public License, version 3, is available at
 *  (http://developer.catrobat.org/license_additional_term)
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see http://www.gnu.org/licenses/.
 */

enum StopScriptStyle: Int, CaseIterable {
    case thisScript = 0
    case allScripts = 1
    case otherScripts = 2

    func localizedString() -> String {
        switch self {
        case .thisScript:
            return kLocalizedThisScript
        case .allScripts:
            return kLocalizedAllScripts
        case .otherScripts:
            return kLocalizeOtherScripts
        }
    }

    static func from(rawValue: Int) -> StopScriptStyle? {
        for style in StopScriptStyle.allCases where style.rawValue == rawValue {
            return style
        }
        return nil
    }

    static func from(localizedString: String) -> StopScriptStyle? {
        for style in StopScriptStyle.allCases where style.localizedString() == localizedString {
            return style
        }
        return nil
    }
}
