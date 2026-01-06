
local shadername = "screenspace_general_8tex"

local mat_8tex = CreateMaterial(shadername .. CurTime(), shadername, {
	["$pixshader"] 			= "general_8tex_ps30";
	["$basetexture"]		= "_rt_fullframefb";
	["$texture1"]			= "_dynamic_cimage_0";
	["$texture2"]			= "__vgui_texture_2";
	["$texture3"]			= "_rt_resolvedfullframedepth";
	["$texture4"]			= "_dynamic_cimage_1";
	["$texture5"]			= "_rt_poweroftwofb";
	["$texture6"]			= "_rt_waterreflection";
	["$texture7"]			= "_rt_waterrefraction";
	-- ["$vertexshader"] 		= "pp_vs30";
	["$vertextransform"] 	= "1";
})

local screentex = render.GetScreenEffectTexture()
local s = 0.25

hook.Add("RenderScreenspaceEffects", shadername, function()
	render.UpdateScreenEffectTexture()
	render.CopyRenderTargetToTexture(screentex)
	render.SetMaterial(mat_8tex)
	render.DrawScreenQuad()

end)

hook.Add("HUDPaint", shadername, function()
	local scrw, scrh = ScrW() * s, ScrH() * s
	local scrw_3 = scrw * 3

	draw.DrawText("$basetexture", "BudgetLabel", 0, scrh)
	draw.DrawText("$texture1", "BudgetLabel", 0, 0)
	draw.DrawText("$texture2", "BudgetLabel", scrw, 0)
	draw.DrawText("$texture3", "BudgetLabel", scrw * 2, 0)
	draw.DrawText("$texture4", "BudgetLabel", scrw_3, 0)
	draw.DrawText("$texture5", "BudgetLabel", scrw_3, scrh)
	draw.DrawText("$texture6", "BudgetLabel", scrw_3, scrh * 2)
	draw.DrawText("$texture7", "BudgetLabel", scrw_3, scrh * 3)
end)

hook.Add("NeedsDepthPass", shadername, function() return true end)

-- hook.Remove("RenderScreenspaceEffects", shadername)
-- hook.Remove("HUDPaint", shadername)
-- hook.Remove("NeedsDepthPass", shadername)
