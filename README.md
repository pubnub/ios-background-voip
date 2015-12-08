# ios-background-voip

Install on phone (this will *NOT* work on sim). Prints messages to console. Will show local notifications (look like push) when you bring the app to the background.

Limitations:
Can only check on VoIP socket a minimum of every 10 minutes. Will most likely continue until then, but if something happens, you have to wait a maximum of 10 minutes to know.

Must use the 'voip' branch of the PubNub SDK. Currently even with master. Check out the Podfile of this project for an example.
