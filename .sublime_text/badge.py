import sublime
import sublime_plugin

class LabBadgeListener(sublime_plugin.EventListener):
    def update_badge(self, view):
        if view and not view.is_loading():
            # Choose your preferred internal lab aesthetic:
            # -------------------------------------------------------------
            # Option A (Cyberpunk / Terminal):
            badge = "⬡ LAB-007 // INTERNAL-ONLY"

            # Option B (Clean Military / Aerospace):
            # badge = "[LAB-007 :: CLASSIFIED]"

            # Option C (Minimal Hardware Station):
            # badge = "SYS:LAB-007 [ACTIVE]"
            # -------------------------------------------------------------

            # "00_" puts it on the far LEFT of the status bar.
            # Change "00_badge" to "zz_badge" to put it on the far RIGHT.
            view.set_status("00_badge", badge)

    def on_activated(self, view):
        self.update_badge(view)

    def on_load(self, view):
        self.update_badge(view)
