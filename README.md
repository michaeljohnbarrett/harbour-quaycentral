# QuayCentral
A GUI app for the 1Password command-line tool on Sailfish OS.

QuayCentral is an unofficial application and is in no way associated with 1Password or AgileBits, Inc.

Licensed under GNU GPLv3.

<h3>Requirements</h3>

- Installation of the 1Password command-line tool in /usr/local/bin or another directory in your $PATH. (The app has not been tested with the tool in a location other than /usr/local/bin).
- Addition of the shorthand "quaycentsfos" to your device's CLI. The shorthand is device-specific. Even if user has already signed in for the first time, a new shorthand may be added by signing in again with domain, email and secret key, along with "--shorthand quaycentsfos". More info on adding the shorthand is available at:<br>
    https://support.1password.com/command-line-reference/#options-for-signin &<br>
    https://1password.community/discussion/comment/561753/#Comment_561753

<h3>Rationale</h3>

- Having a 1Password client that keeps Ambience on user's device, providing for a better and more consistent SFOS experience.
- Official 1Password app that supports 1Password.com accounts requires Android version 5 or greater and is therefore incompatible with Alien Dalvik on Xperia X.
- Overall plus to have more native SFOS apps and fewer dependencies on Android versions, experimenting with how different apps may utilize the interface that SFOS provides.

<h3>Limitations & Issues</h3>

- As of now, only shows items in the Login category and shows username, password, and one-time password (if applicable) for each item. Plan to add more categories and eventually all.
- Items are read-only, plan to add editing capability at some point in the future.
- Timeout only applies to the app's interaction with the CLI, i.e. swiping back a page, going to Settings, or scrolling down a list, etc. will not reset the lockout timer.
- Leaving the app open on an item details page that includes a TOTP (one-time password) will mean the lockout timer never times out, as it will keep resetting every 30 seconds a new code is generated.
- No support for multiple accounts or for groups. (No plans for this, app is designed for individual use.)
- Items are not listed alphabetically so search method is, for now, necessary as opposed to scrolling through a list.
- Option to select a default vault and possibly more vault management, similar to the official app, is on hold until I have a Sailfish Secrets implementation to provide the secure storage that may be required for data such as a default vault UUID.
- Clipboard icon on item details page may be somewhat misaligned if text size is enlarged on a device's Display Settings. Will edit code to work around this somehow, prefer the medium clipboard icon to the small one, there is no small-plus icon size for the clipboard icon as of now.
- Lock icon on cover may appear somewhat smaller than other standard cover icons. No lock icon available under the Cover category so went with the small icon for now.
- No app icon yet.
- No setup screen to allow user to enter necessary credentials to signin with the app for the first time and avoid having to add the shorthand manually in Terminal. May add this later, clearing all fields as soon as data is passed to the CLI as is done with the master password. With the pre-determined quaycentsfos shorthand, there's currently no need for the storage of any secrets, i.e. user's own domain/shorthand.
- Button on Settings page meant to signout and forget the QuayCentral shorthand does not function and may require that the user first removes the CLI on that device from their list of authorized devices on their profile page at my.1password.com, followed by a device restart and also going back into Terminal to complete with the 'forget' command. This removes the justification for the button being in Settings in the app, since user would have to re-verify the app to get to it. Will re-check functionality in future CLI versions as this would be a cleaner and more preferrable way to allow the user to remove login access to their Vaults from QuayCentral for any given reason, easily and quickly. This issue has been referred to on the 1Password Community support pages and can be read about here:<br>
    https://1password.community/discussion/119973/can-not-signout-account

<h3>Privacy & Security</h3>

- User locks vault(s) by simply swiping back to Sign-in page. An option to lock is also in a push-up menu on the Item Details page. Another easy option is to tap the padlock on the app Cover on the home screen.
- By assigning the shorthand "quaycentsfos", app is able to avoid requiring any secrets to be stored. User also has control over what accounts that that shorthand is associated with, incase they'd like to use the CLI for separate accounts and not use a GUI for all, or to continue using the CLI after revoking QuayCentral signin access, etc. While the default domain value "my" is now the only option available to new users (AFAIK), it was the case previously that personalized domains could be chosen, hence the classification of this information as secret.
- Master password entered by user is cleared immediately following its passing to the CLI and is never stored. Item usernames and passwords are only ever in RAM, are cleared when the vault(s) are locked, and are only copied to the clipboard if user so chooses.
- May add optional timer (similar to official apps) so that user can designate a time after which clipboard is cleared following a password or username being copied. It will require a string variable in RAM to cross reference clipboard contents (and avoid deleting unrelated data that user may have put on clipboad in the meantime), after which both clipboard and string variable will be erased.
- Overall the app is able to avoid privacy or security issues due to the CLI naturally handling all of that processing and encryption.
- When removing the login access for QuayCentral, user will need to get back into Terminal but may also need to remove the CLI from authorized devices on their 1Password profile page. Looking to enable a button in Settings that does this (signs out and forgets the "quaycentsfos" shorthand, thereby removing any access without a need for user to open Terminal) but there appear to be issues with the CLI preventing it from functioning properly as of version 1.8.0. Info on how to sign out directly in Terminal, as well as using the 'forget' flag and command, are here:<br>
    https://support.1password.com/command-line-reference/#signout <br>
    https://support.1password.com/command-line-reference/#forget

<h3>Contact</h3>

If you would like to send feedback regarding the app, please email mjbarrett@eml.cc with the subject "QuayCentral Feedback".

If you would like to support my work in developing native Sailfish OS apps (this would bring my status closer to full-time developer), you're welcome to here! -- https://www.buymeacoffee.com/michaeljb <br>
<br>
Thanks,<br>
Michael B.
