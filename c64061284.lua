--古代の機械融合
---@param c Card
function c64061284.initial_effect(c)
	aux.AddCodeList(c,83104731)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c64061284.target)
	e1:SetOperation(c64061284.activate)
	c:RegisterEffect(e1)
end
function c64061284.fcheck(tp,sg,fc)
	if sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
		return sg:IsExists(c64061284.filterchk,1,nil) end
	return true
end
function c64061284.filterchk(c)
	return c:IsCode(83104731,95735217) and c:IsOnField()
end
function c64061284.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c64061284.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c64061284.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x7) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c64061284.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c64061284.filter0,tp,LOCATION_DECK,0,nil)
		if mg:IsExists(c64061284.filterchk,1,nil) and mg2:GetCount()>0 then
			mg:Merge(mg2)
			aux.FCheckAdditional=c64061284.fcheck
		end
		local res=Duel.IsExistingMatchingCard(c64061284.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
		aux.FCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c64061284.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
end
function c64061284.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c64061284.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(c64061284.filter0,tp,LOCATION_DECK,0,nil)
	if mg1:IsExists(c64061284.filterchk,1,nil) and mg2:GetCount()>0 then
		mg1:Merge(mg2)
		aux.FCheckAdditional=c64061284.fcheck
	end
	local sg1=Duel.GetMatchingGroup(c64061284.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=nil
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c64061284.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	local sg=sg1:Clone()
	if sg2 then sg:Merge(sg2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=sg:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	if not tc then return end
	if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
		aux.FCheckAdditional=c64061284.fcheck
		local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		tc:SetMaterial(mat1)
		Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	else
		local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
		local fop=ce:GetOperation()
		fop(ce,e,tp,tc,mat2)
	end
	tc:CompleteProcedure()
end
