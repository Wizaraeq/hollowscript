--拡散する波動
function c87880531.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c87880531.condition)
	e1:SetCost(c87880531.cost)
	e1:SetTarget(c87880531.target)
	e1:SetOperation(c87880531.activate)
	c:RegisterEffect(e1)
end
function c87880531.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c87880531.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c87880531.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsLevelAbove(7)
end
function c87880531.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c87880531.filter(chkc) end
	if chk==0 then return Duel.IsAbleToEnterBP() and Duel.IsExistingTarget(c87880531.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c87880531.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c87880531.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsControler(tp) and tc:IsRelateToEffect(e) then
		local ae=Effect.CreateEffect(e:GetHandler())
		ae:SetType(EFFECT_TYPE_FIELD)
		ae:SetCode(EFFECT_CANNOT_ATTACK)
		ae:SetTargetRange(LOCATION_MZONE,0)
		ae:SetTarget(c87880531.ftarget)
		ae:SetLabel(tc:GetFieldID())
		ae:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(ae,tp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_MUST_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ATTACK_ALL)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_BATTLED)
		e4:SetOperation(c87880531.disop)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
	end
end
function c87880531.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c87880531.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if not bc or not bc:IsStatus(STATUS_BATTLE_DESTROYED) then return end
	local e1=Effect.CreateEffect(e:GetOwner())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetReset(RESET_EVENT+0x17a0000)
	e1:SetCondition(c87880531.con)
	bc:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE)
	bc:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_DISABLE_EFFECT)
	bc:RegisterEffect(e3)
end
function c87880531.con(e)
	return e:GetHandler():IsType(TYPE_MONSTER)
end