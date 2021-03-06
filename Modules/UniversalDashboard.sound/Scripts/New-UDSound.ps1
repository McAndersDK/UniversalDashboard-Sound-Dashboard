<#
.SYNOPSIS
    Sample control for UniversalDashboard.
.DESCRIPTION
    Sample control function for UniversalDashboard. This function must have an ID and return a hash table.
.PARAMETER Id
    An id for the component default value will be generated by new-guid.
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
function New-UDSound {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Id = (New-Guid).ToString(),
        [Parameter()]
        [string]$URL,
        # Start play at miliseconds
        [Parameter()]
        [int]
        $PlayFromPosition = 0,
        [Parameter()]
        [ValidateRange(0, 100)]
        [int]
        $Volume = 100,
        [parameter()]
        [validateset('PLAYING', 'STOPPED', 'PAUSED')]
        [String]
        $PlayStatus,
        [switch]
        $Loop,
        [switch]
        $AutoStart,
        [int]
        $PlaybackRate = 1,
        [Parameter()]
        [object]$OnError,
        [Parameter()]
        [object]$OnLoading,
        [Parameter()]
        [object]$OnLoad,
        [Parameter()]
        [object]$OnPlaying,
        [Parameter()]
        [object]$OnPause,
        [Parameter()]
        [object]$OnResume,
        [Parameter()]
        [object]$OnStop,
        [Parameter()]
        [object]$OnFinishedPlaying,
        [Parameter()]
        [object]$OnBufferChange
    )

    End {
        $Callbacks = 'OnError', 'OnLoading', 'OnLoad', 'OnPlaying', 'OnPause', 'OnResume', 'OnStop', 'OnFinishedPlaying', 'OnBufferChange'
        foreach ($Callback in $Callbacks) {
            if ($PSCmdlet.MyInvocation.BoundParameters[$Callback].IsPresent) {
                $CallbackVariable = Get-Variable -Name $Callback
                if ($CallbackVariable -is [scriptblock]) {
                    $CallbackVariable = New-UDEndpoint -Endpoint $CallbackVariable -Id ($Id + $Callback)
                }
                elseif ($CallbackVariable -isnot [UniversalDashboard.Models.Endpoint]) {
                    throw "$Callback must be a script block or UDEndpoint."
                }
                Set-Variable "active$Callback" -value "true"
            }
            else {
                Set-Variable "active$Callback" -Value "false"
            }
        }
        @{
            # The AssetID of the main JS File
            assetId                 = $AssetId
            # Tell UD this is a plugin
            isPlugin                = $true
            # This ID must be the same as the one used in the JavaScript to register the control with UD
            type                    = "ud-sound"
            # An ID is mandatory
            id                      = $Id
            # This is where you can put any other properties. They are passed to the React control's props
            # The keys are case-sensitive in JS.
            url                     = $URL
            playStatus              = $PlayStatus
            playFromPosition        = $PlayFromPosition
            position                = $Position
            volume                  = $Volume
            playbackRate            = $PlaybackRate
            loop                    = $Loop
            autoLoad                = $AutoStart
            activeOnError           = $activeOnError
            activeOnLoading         = $activeOnLoading
            activeOnLoad            = $activeOnLoad
            activeOnPlaying         = $activeOnPlaying
            activeOnPause           = $activeOnPause
            activeOnResume          = $activeOnResume
            activeOnStop            = $activeOnStop
            activeOnFinishedPlaying = $activeOnFinishedPlaying
            activeOnBufferChange    = $activeOnBufferChange
            # url (string): The url of the sound to play.
            # playStatus (Sound.status.{PLAYING,STOPPED,PAUSED}): The current sound playing status. Change it in successive renders to play, stop, pause and resume the sound.
            # playFromPosition (number): Seeks to the position specified by this prop, any time it changes. After that, the sound will continue playing (or not, if the playStatus is not PLAYING). Use this prop to seek to different positions in the sound, but not use it as a controlled component. You should use either this prop or position, but not both.
            # position (number): The current position the sound is at. Use this to make the component a controlled component, meaning that you must update this prop on every onPlaying callback. You should use either this prop or playFromPosition, but not both.
            # volume (number): The current sound's volume. A value between 0 and 100.
            # playbackRate (number): Number affecting sound playback. A value between 0.5 and 4 of normal rate (1).
            # autoLoad (boolean): If the sound should start loading automatically (defaults to false).
            # loop (boolean): If the sound should continue playing in a loop (defaults to false).
            # onError (function): Function that gets called when the sound fails to load, or fails during load or playback. It receives the arguments errorCode and description with details about the error.
            # onLoading (function): Function that gets called while the sound is loading. It receives an object with properties bytesLoaded, bytesTotal and duration.
            # onLoad (function): Function that gets called after the sound has finished loading. It receives an object with property loaded, a boolean set to true if the sound has finished loading successfully.
            # onPlaying (function): Function that gets called while the sound is playing. It receives an object with properties position and duration.
            # onPause (function): Function that gets called when the sound is paused. It receives an object with properties position and duration.
            # onResume (function): Function that gets called while the sound is resumed playing. It receives an object with properties position and duration.
            # onStop (function): Function that gets called while the sound playback is stopped. It receives an object with properties position and duration.
            # onFinishedPlaying (function): Function that gets called when the sound finishes playing (reached end of sound). It receives no parameters.
            # onBufferChange (function): Function that gets called when the sound buffering status changes. It receives a single boolean representing the buffer state.
        }

    }
}
