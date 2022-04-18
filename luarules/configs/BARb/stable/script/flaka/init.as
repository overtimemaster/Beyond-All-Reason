#include "../common.as"
#include "../unit.as"


namespace Init {

SInitInfo AiInit()
{
	AiLog("flaka AngelScript Rules!");

	SInitInfo data;
	data.armor = InitArmordef();
	data.category = InitCategories();
	@data.profile = @(array<string> = {"behaviour", "block_map", "build_chain", "commander", "economy", "factory", "response"});
	return data;
}

}
