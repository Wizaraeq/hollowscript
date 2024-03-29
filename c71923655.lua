--シャークラーケン
function c71923655.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c71923655.spcon)
	e1:SetOperation(c71923655.spop)
	c:RegisterEffect(e1)
end
function c71923655.spfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_WATER)
		and Duel.GetMZoneCount(tp,c)>0 and (c:IsControler(tp) or c:IsFaceup())
end
function c71923655.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(tp,c71923655.spfilter,1,nil,tp)
end
function c71923655.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectReleaseGroup(tp,c71923655.spfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
