{
 "policies": {
   "AutofillCreditCardEnabled": false,
   "Cookies": {
     "Behavior": "reject-tracker-and-partition-foreign",
     "BehaviorPrivateBrowsing": "reject-tracker-and-partition-foreign"
   },
   "DisableFirefoxStudies": true,
   "DisablePocket": true,
   "DisableTelemetry": true,
   "DNSOverHTTPS": {
      "Enabled": false
   },
   "EnableTrackingProtection": {
      "Value": true,
      "Cryptomining": true,
      "Fingerprinting": true,
      "EmailTracking": true,
      "SuspectedFingerprinting": true,
      "Category": "strict"
   },
   "HardwareAcceleration": true,
   "Homepage": {
      "URL": "about:blank",
      "StartPage": "previous-session"
   },
   "HttpsOnlyMode": "enabled",
   "MicrosoftEntraSSO": true,
   "NewTabPage": false,
   "NoDefaultBookmarks": true,
   "Preferences": {
     "dom.private-attribution.submission.enabled": {
       "Value": true,
       "Status": "user"
     },
     "browser.ml.chat.enabled": {
       "Value": false,
       "Status": "user"
     },
     "browser.ml.chat.sidebar": {
       "Value": false,
       "Status": "user"
     }
   },
   "OfferToSaveLogins": false,
   "SearchEngines": {
      "Default": "DuckDuckGo",
      "Remove": [
        "Google",
        "Bing",
        "Amazon.de",
        "eBay",
        "Ecosia",
        "LEO Eng-Deu",
        "Wikipedia (de)"
      ]
   }
 }
}
