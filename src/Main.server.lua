
local DockWidgetHandler = require(script.Parent.DockWidgetHandler)

local app = script.Parent.app
local importMenu = require(app.importMenu)
local exportMenu = require(app.exportMenu)

local toolbar = plugin:CreateToolbar("NL2ToRoblox")

local importButton = toolbar:CreateButton("Import", "Import Tracks from No Limits 2", "", "")
importButton.ClickableWhenViewportHidden = true
DockWidgetHandler.new(plugin, importButton, "NL2Import", "NL2ToRoblox Import", importMenu)

local exportButton = toolbar:CreateButton("Export", "Export Tracks to No Limits 2", "", "")
exportButton.ClickableWhenViewportHidden = true
DockWidgetHandler.new(plugin, exportButton, "NL2Export", "NL2ToRoblox Export", exportMenu)
