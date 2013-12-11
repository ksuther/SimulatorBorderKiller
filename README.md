# SimulatorBorderKiller

Make the iOS Simulator ever-so-slightly less annoying.

## What is this?

SimulatorBorderKiller does two things:

#### 1. Hides the device border around the simulator window

Normally, the iOS Simulator only hides the device border when you shrink it to 75% or 50%. SimulatorBorderKiller allows you to show just the titlebar even when running at 100% scale. Keep the simulator nice and large without sacrificing space.

#### 2. Shows you the current device orientation in the titlebar

Now that the device border is always hidden, which way is up? This adds the device orientation to the window's title. Never end up upside down by accident again!

![Screenshot](https://raw.github.com/ksuther/SimulatorBorderKiller/master/screenshot.jpg)

## How do I use it?

1. Install a SIMBL-loading system, such as [EasySIMBL](https://github.com/norio-nomura/EasySIMBL/)
1. Build the project or [download the latest release](https://github.com/ksuther/SimulatorBorderKiller/releases/download/v0.1/SimulatorBorderKiller_0.1.zip)
1. Move `SimulatorBorderKiller.bundle` into `~/Library/Application Support/SIMBL/Plug-ins`
1. Relaunch the iOS Simulator

## Version compatibility

Developed and tested against Xcode 5.0.2 and 5.1DP1. In order to avoid potential incompatibilities with future versions of the iOS Simulator, `MaxBundleVersion` is set inside `SIMBLTargetApplications` in the Info.plist. You will need to update `MaxBundleVersion` to ensure SIMBL loads the bundle into future versions of the iOS Simulator.

## License

MIT License

    Copyright (c) 2013 Kent Sutherland
    
    Permission is hereby granted, free of charge, to any person obtaining a copy of
    this software and associated documentation files (the "Software"), to deal in
    the Software without restriction, including without limitation the rights to use,
    copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
    Software, and to permit persons to whom the Software is furnished to do so,
    subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.