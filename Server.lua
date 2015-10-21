--
	--
		--# Created By MoDeR2014 'never remove the credits'
	--
--

-- ***************************** --
-- ***************************** --

--[[
	This script was made under the MTA AR Scripting Challenge
	تم تصميم هذا المود تحت تحدي البرمجة العربي 
	
	http://forum.mtasa.com/viewtopic.php?f=119&t=93698

--]]
-- ****************************** --
-- ****************************** --

Main = {
	Object,
	Marker,
	isChairUsed = false,
	playerInChair = nil,
};

Main["Object"] = createObject(1714, 213, 1822.85, 5.41, 0, 0, 270);
Main["Marker"] = createMarker(212.85, 1822.9, 5.41, "cylinder", 1.6, 255, 255, 255, 20);
Blip.createAttachedTo(Main["Marker"], 5, 2, 255, 255, 255, 255, 0, 500);

function guiShowMessageBox(player, message, boxType, title)
	triggerClientEvent(player, "AirStrike:MessageBox", player, message, boxType, title);
end

function showMenu(player)
	if player:isWithinMarker(Main["Marker"]) then
		if not Main["isChairUsed"] then
			Main["isChairUsed"] = true
			Main["playerInChair"] = player
			player:setPosition(212.45, 1822.854, 6.41);
			player:setFrozen(true);
			player:setAnimation("INT_OFFICE", "OFF_Sit_Type_Loop", -1, true, false);
			setPedRotation(player, 90.59);
			triggerClientEvent(player, "AirStrike:toggleGUI", player);
		end
	else
		if isKeyBound(player, "tab", "down", showMenu) then
			unbindKey(player, "tab", "down", showMenu);
		end
	end
end

addEvent("AirStrike:onGUIClose", true);
addEventHandler("AirStrike:onGUIClose", root,
function ( client )
	if Main["playerInChair"] == client then
		client:setFrozen(false);
		client:setAnimation(false);
		Main["isChairUsed"] = false
		Main["playerInChair"] = nil
	end
end );

addEvent("AirStrike:takeMoney", true);
addEventHandler("AirStrike:takeMoney", root,
function ( client, Amount )
	if Main["playerInChair"] == client then
		client:takeMoney(Amount);
	end
end );

addEvent("AirStrike:SendMissiles", true);
addEventHandler("AirStrike:SendMissiles", root,
function ( client, Pos )
	if Main["playerInChair"] == client then
		triggerClientEvent(root, "AirStrike:reG", root, Pos, client);
	end
end );

addEventHandler("onMarkerHit", Main["Marker"],
function (hitElement, matchingDimension)
	if hitElement:getType() == "player" and matchingDimension then
		if not Main["isChairUsed"] then
			bindKey(hitElement, "tab", "down", showMenu, hitElement);
		else
			guiShowMessageBox(hitElement, "AirStrike is already used by "..getPlayerName(Main["playerInChair"]), "error", "Error");
		end
	end
end );

addEventHandler("onMarkerLeave", Main["Marker"],
function ( leaveElement, matchingDimension )
	if leaveElement:getType() == "player" and matchingDimension then
		if isKeyBound(leaveElement, "tab", "down", showMenu) then
			unbindKey(leaveElement, "tab", "down", showMenu);
		end
	end
end );

function DonnoWhatIShouldNameThisFunction()
	if Main["playerInChair"] ~= nil and Main["playerInChair"] == source then
		Main["isChairUsed"] = false
		Main["playerInChair"] = nil
	end
end
addEventHandler("onPlayerStealthKill", root, DonnoWhatIShouldNameThisFunction);
addEventHandler("onPlayerQuit", root, DonnoWhatIShouldNameThisFunction);
addEventHandler("onPlayerWasted", root, DonnoWhatIShouldNameThisFunction);
