-- Pl/Sql Developer Lua Plug-In Addon: Edit


-- Variables

local AddMenu = ...

local plsql = plsql
local SYS, IDE, SQL = plsql.sys, plsql.ide, plsql.sql

local ShowMessage = plsql.ShowMessage

local Gsub, Sub, Upper, Lower = string.gsub, string.sub, string.upper, string.lower


-- Scroll Up/Down
do
	local upMenuItem

	local function Scroll(menuItem)
		local step = (menuItem == upMenuItem) and -1 or 1
		IDE.LineScroll(0, step)
		IDE.SetCursor(0, IDE.GetCursorY() + step)
	end

	upMenuItem = AddMenu(Scroll, "Lua / Edit / Scroll Up")
	AddMenu(Scroll, "Lua / Edit / Scroll Down")
end


-- Duplicate selected text
do
	local function Duplicate()
		local text = IDE.GetSelectedText()

		IDE.SetCursor(0, 0)
		IDE.InsertText(text)
	end

	AddMenu(Duplicate, "Lua / Edit / Selection / Duplicate")
end

-- Inverse Special Copy (Java, C++)
do
	local function InverseSpecial()
		local text = IDE.GetSelectedText()

		text = Gsub(text, "^[^\"]*\"", '')  -- Text head
		text = Gsub(text, "\"[^\"]*$", '')  -- Text tail
		text = Gsub(text, "\n[^\"]*\"", '\n')  -- Line head
		text = Gsub(text, "[ \t]*\"[^\"\r\n]*([\r\n])", '%1')  -- Line tail
		text = Gsub(text, "\"[^\"\n]+\"", '1')  -- Line middles
		IDE.InsertText(Gsub(text, "\\n", ''))
	end

	AddMenu(InverseSpecial, "Lua / Edit / Selection / Inverse Special")
end


-- Init Caps
do
	local function Capitalize(s)
		if #s == 1 then
			return Lower(s)
		end
		return Upper(Sub(s, 1, 1)) .. Lower(Sub(s, 2))
	end

	local function InitCaps()
		local text = IDE.GetSelectedText()

		IDE.InsertText(Gsub(text, "%w+", Capitalize))
	end

	AddMenu(InitCaps, "Lua / Edit / Selection / Init Caps")
end

-- Highlight Snippet
do
	local function ExecuteSnippet(s)
		if #s == 1 then
			return Lower(s)
		end
		return Upper(Sub(s, 1, 1)) .. Lower(Sub(s, 2))
	end

	local function EXECSnippet()
		local text = IDE.GetText()
		local result = ""
		local linenumber = 1
		local currentline = IDE.GetCursorY()


		for line in text:gmatch("([^\n]*)\n?") do
  		-- do something
                  	if string.len(line) > 1 then 
                  		--IDE.InsertText(string.len(line))
				--IDE.InsertText("\n")
				--IDE.InsertText(line)
                                result = result .. line
			else
				if linenumber < currentline then 
					result = ""
				else
					break
				end 
			end
                    linenumber = linenumber + 1 
		end
		--IDE.InsertText(result)

		SQL.Execute(result)

		--IDE.InsertText(text)
		--local liney = IDE.GetCursorY()
        	--IDE.InsertText(liney)

		--IDE.InsertText(Gsub(text, "%w+", ExecuteSnippet)))
	end

	AddMenu(EXECSnippet, "Lua / Edit / Selection / ExecuteSnippet")
end



-- Strip trailing spaces of the lines
do
	local function ClearBlanks()
		local text = IDE.GetSelectedText()

		text = Gsub(text, "[ \t]+$", "")
		IDE.InsertText(Gsub(text, "[ \t]+([\r\n])", "%1"))
	end

	AddMenu(ClearBlanks, "Lua / Edit / Selection / Clear Blanks")
end


-- Copy selected text to new SQL window
do
	local function ToSqlWindow()
		local text = IDE.GetSelectedText()

		IDE.CreateWindow(plsql.WindowType.SQL, text)
	end

	AddMenu(ToSqlWindow, "Lua / Edit / Selection / SQL Window")
end


-- Addon description
local function About()
	return "Edit Utilities"
end


return {
	OnActivate,
	OnDeactivate,
	CanClose,
	AfterStart,
	AfterReload,
	OnBrowserChange,
	OnWindowChange,
	OnWindowCreate,
	OnWindowCreated,
	OnWindowClose,
	BeforeExecuteWindow,
	AfterExecuteWindow,
	OnConnectionChange,
	OnWindowConnectionChange,
	OnPopup,
	OnMainMenu,
	OnTemplate,
	OnFileLoaded,
	OnFileSaved,
	About,
	CommandLine,
	RegisterExport,
	ExportInit,
	ExportFinished,
	ExportPrepare,
	ExportData
}

