#include "../../define.as"


namespace Economy {

void AiOpenStrategy(const CCircuitDef@ facDef, const AIFloat3& in pos)
{
}

/*
 * struct SResourceInfo {
 *   const float current;
 *   const float storage;
 *   const float pull;
 *   const float income;
 * }
 */
void AiUpdateEconomy()
{
	const SResourceInfo@ metal = aiEconomyMgr.metal;
	const SResourceInfo@ energy = aiEconomyMgr.energy;
	aiEconomyMgr.isMetalEmpty = metal.current < metal.storage * 0.2f;
	aiEconomyMgr.isMetalFull = metal.current > metal.storage * 0.8f;
	if (ai.frame < 2 * MINUTE) {  // if (aiFactoryMgr.GetFactoryCount() == 0) {
		aiEconomyMgr.isEnergyEmpty = false;
		aiEconomyMgr.isEnergyStalling = (energy.income < energy.pull) && (energy.current < energy.storage * 0.3f);
	} else {
		aiEconomyMgr.isEnergyEmpty = energy.current < energy.storage * 0.2f;
		aiEconomyMgr.isEnergyStalling = aiEconomyMgr.isEnergyEmpty || ((energy.income < energy.pull) && (energy.current < energy.storage * 0.6f));
	}
	// NOTE: Default energy-to-metal conversion TeamRulesParam "mmLevel" = 0.75
	aiEconomyMgr.isEnergyFull = energy.current > energy.storage * 0.88f;
}

}  // namespace Economy
