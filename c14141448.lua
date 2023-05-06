--グレート・モス
function c14141448.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c14141448.spcon)
	e2:SetOperation(c14141448.spop)
	c:RegisterEffect(e2)
end
function c14141448.eqfilter(c)
	return c:IsCode(40240595) and c:GetTurnCounter()>=4
end
function c14141448.rfilter(c,tp)
	return c:IsCode(58192742) and c:GetEquipGroup():IsExists(c14141448.eqfilter,1,nil) and Duel.GetMZoneCount(tp,c)>0
end
function c14141448.spcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),c14141448.rfilter,1,nil,tp)
end
function c14141448.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),c14141448.rfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
