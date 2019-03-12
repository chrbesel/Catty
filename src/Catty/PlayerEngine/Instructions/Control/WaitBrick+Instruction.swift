/**
 *  Copyright (C) 2010-2019 The Catrobat Team
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

@objc extension WaitBrick: CBInstructionProtocol {

    @nonobjc func instruction(audioEngine: AudioEngine) -> CBInstruction {

        guard let object = self.script?.object
            else { fatalError("This should never happen!") } // (pre)fetch only once (micro-optimization)

        return CBInstruction.waitExecClosure { context, scheduler in
            let waitUntilWaitTimeOver = NSCondition()
            waitUntilWaitTimeOver.accessibilityHint = "0"
            let durationInSeconds = context.formulaInterpreter.interpretDouble(self.timeToWaitInSeconds, for: object)

            let durationTimer = ExtendedTimer.init(timeInterval: durationInSeconds,
                                                   repeats: false,
                                                   execOnCurrentRunLoop: false,
                                                   startTimerImmediately: false) {_ in
                waitUntilWaitTimeOver.accessibilityHint = "1"
                waitUntilWaitTimeOver.signal()
            }

            (scheduler as! CBScheduler).setTimer(durationTimer)
            waitUntilWaitTimeOver.lock()
            while waitUntilWaitTimeOver.accessibilityHint == "0" { //accessibilityHint used because synthesizer.speaking not yet true.
                waitUntilWaitTimeOver.wait()
            }
            waitUntilWaitTimeOver.unlock()
            (scheduler as! CBScheduler).removeTimer(durationTimer)
        }
    }
}
