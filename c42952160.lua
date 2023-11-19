--冥府の合わせ鏡
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then return false end
	return r&REASON_BATTLE>0 and Duel.GetAttacker():IsControler(1-tp) or r&REASON_EFFECT>0 and rp==1-tp
end
function s.filter(c,v,e,tp)
	return c:IsAttackBelow(v) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local is_eff=(r&REASON_EFFECT)==REASON_EFFECT
	if chk==0 then return is_eff or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,ev,e,tp))
	end
	if is_eff then
		e:SetCategory(CATEGORY_DAMAGE)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ev*2)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ss=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter),tp,LOCATION_GRAVE,0,1,nil,ev,e,tp)
	local op=0
	if r&(REASON_BATTLE+REASON_EFFECT)==REASON_BATTLE+REASON_EFFECT then
		op=aux.SelectFromOptions(tp,{ss,aux.Stringid(id,1)},{true,aux.Stringid(id,2)})
	elseif r&REASON_BATTLE>0 then
		op=1
	else
		op=2
	end
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,ev,e,tp)
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_DAMAGE_STEP_END)
			e1:SetOperation(s.skipop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
			Duel.RegisterEffect(e1,tp)
		end
	else
		Duel.Damage(1-tp,ev*2,REASON_EFFECT)
	end
end
function s.skipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
end