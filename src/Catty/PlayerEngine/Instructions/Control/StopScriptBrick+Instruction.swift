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

extension StopScriptBrick: CBInstructionProtocol {

    @nonobjc func instruction() -> CBInstruction {
        CBInstruction.waitExecClosure { context, scheduler in
            switch self.selection {
            case .thisScript:
                scheduler.stopContext(context, continueWaitingBroadcastSenders: false)

                for sound in context.soundList {
                    scheduler.getAudioEngine().stopAudio(for: self.script.object.name, and: sound)
                }
            case .allScripts:
                for ct in scheduler.getContexts() {
                    scheduler.stopContext(ct, continueWaitingBroadcastSenders: false)
                    scheduler.getAudioEngine().stop()
                }
            case .otherScripts:
                for ct in scheduler.getContexts() where ct.id != context.id
                    && ct.script.object.name == context.script.object.name {
                    scheduler.stopContext(ct, continueWaitingBroadcastSenders: false)

                    for sound in ct.soundList {
                        scheduler.getAudioEngine().stopAudio(for: ct.script.object.name, and: sound)
                    }
                }
            }
        }
    }
}
