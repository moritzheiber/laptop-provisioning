table.insert(alsa_monitor.rules,
  {
    matches = {
      {
        { "device.name", "matches", "alsa_card.usb-Focusrite*" },
      },
    },
    apply_properties = {
      ["api.acp.probe-rate"]             = 44100,
    },
  }
)

table.insert(alsa_monitor.rules,
  {
    matches = {
      {
        { "device.name", "matches", "alsa_card.usb-Logi_Logi_Dock*" },
      },
    },
    apply_properties = {
      ["api.alsa.ignore-dB"]             = true,
    },
  }
)
