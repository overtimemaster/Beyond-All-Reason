local pad,base,door1,door2,crane1,crane2,turret1,turret2,nano1,nano2  = piece("pad","base","door1","door2","crane1","crane2","turret1","turret2","nano1","nano2");

local spray = 0;

local SIG_ACTIVATE = 2;
local SIG_OPENCLOSE = 4;
local SIG_CRANE1=8;
local SIG_CRANE2=16;

include("include/util.lua");

function open()
	UnitScript.Signal(SIG_OPENCLOSE);
	UnitScript.SetSignalMask(SIG_OPENCLOSE);
	--Activate
	Move(door1, x_axis, -17, 10);
	Move(door2, x_axis, 17, 10);
	UnitScript.WaitForMove(door1, x_axis);
	Move(crane1,x_axis,21,42);
	Move(crane2,x_axis,21,42);
	UnitScript.WaitForMove(crane1, x_axis);
	Sleep(1000);	
	--Open yard
	open_yard();
	--Get into buildstance
	UnitScript.SetUnitValue(COB.INBUILDSTANCE, 1);
end

function close()
	UnitScript.Signal(SIG_OPENCLOSE);
	UnitScript.SetSignalMask(SIG_OPENCLOSE);
	--Get out of buildstance
	UnitScript.SetUnitValue(COB.INBUILDSTANCE, 0);
	--Close yard
	close_yard();
	--Deactivate
	Move(crane1,x_axis,2,20);
	Move(crane2,x_axis,2,20);
	UnitScript.WaitForMove(crane1, x_axis);
	Move(door1, x_axis, 0, 17);
	Move(door2, x_axis, 0, 17);
	UnitScript.WaitForMove(door1, x_axis);
	Sleep(500)
end

function script.Create()
	spray = 0;
	UnitScript.StartThread(smoke_unit, base);
end

function script.QueryNanoPiece()
	local piecenum;
	if (spray == 0) then
		piecenum = nano1;
	end
	if (spray == 1) then
		piecenum = nano2;
	end
	spray = spray + 1;
	if(spray == 2) then
		spray = 0;
	end
	return piecenum;
end

function Activate_real()
	UnitScript.Signal(SIG_ACTIVATE);
	UnitScript.StartThread(open);

end

function script.Activate()
	UnitScript.StartThread(Activate_real);
end

function Deactivate_real()
	UnitScript.Signal(SIG_ACTIVATE);
	UnitScript.SetSignalMask(SIG_ACTIVATE);
	Sleep(5000)
	UnitScript.StartThread(close);
end

function script.Deactivate()
	UnitScript.StartThread(Deactivate_real);
end

local function MoveCrane1()
    Signal(SIG_CRANE1);
    SetSignalMask(SIG_CRANE1);
    
	while true do
        Move(crane1,x_axis, 40,10);
        WaitForMove(crane1, x_axis);
        Move(crane1,x_axis, 2, 10);
        WaitForMove(crane1, x_axis);
    end
end

local function MoveCrane2()
    Signal(SIG_CRANE2);
    SetSignalMask(SIG_CRANE2);
    
    while true do
        Move(crane2,x_axis, 2,10);
        WaitForMove(crane2, x_axis);
        Move(crane2,x_axis, 40, 10);
        WaitForMove(crane2, x_axis);
    end
end

function script.StartBuilding(heading, pitch)
	StartThread(MoveCrane1);
	StartThread(MoveCrane2);
end

function script.StopBuilding()
	Signal(SIG_CRANE1);
	Signal (SIG_CRANE2);
	Move(crane1,x_axis, 20, 20);
	Move(crane2,x_axis, 20, 20);
end

function script.QueryBuildInfo()
	return pad;
end

function script.Killed(recentDamage, maxHealth)
	local severity = (recentDamage / maxHealth) * 100;
	local corpsetype;
	
	if (severity <= 25) then
		corpsetype = 1;
		UnitScript.Explode(base,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(door1,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(door2,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(turret1,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(turret2,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(nano1,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(nano2,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(crane1,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(crane2,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(pad,SFX.NONE + SFX.NO_HEATCLOUD);
		return corpsetype;
	end
	if (severity <= 50) then
		corpsetype = 2;
		UnitScript.Explode(base,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(door1,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(door2,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(turret1,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(turret2,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(nano1,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(nano2,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(crane1,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(crane2,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(pad,SFX.NONE + SFX.NO_HEATCLOUD);
		return corpsetype;
	end
	if (severity <= 99) then
		corpsetype = 3;
		UnitScript.Explode(base,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(door1,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(door2,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(turret1,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(turret2,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(nano1,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(nano2,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(crane1,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(crane2,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(pad,SFX.NONE + SFX.NO_HEATCLOUD);
		return corpsetype;
	end
	corpsetype = 3;
		UnitScript.Explode(base,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(door1,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(door2,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(turret1,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(turret2,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(nano1,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(nano2,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(crane1,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(crane2,SFX.NONE + SFX.NO_HEATCLOUD);
		UnitScript.Explode(pad,SFX.NONE + SFX.NO_HEATCLOUD);
	return corpsetype;
end
