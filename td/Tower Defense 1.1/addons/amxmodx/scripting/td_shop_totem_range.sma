#include <amxmodx>
#include <td>

new iItem;
public plugin_init()
{
	new id = register_plugin("TD: SHOP| Range totem", "1.0", "GT Team")
	iItem = td_shop_register_item("Range totem for turrets", "+25 percent to range for nearest turrets.", 100, 0, id)
}

public td_shop_item_selected(id, itemid)
{
	if(iItem == itemid)
	{
		if(td_turrets_get_player_totem(id))
		{
			client_print(id, print_center, "You alerady have totem!");
			return PLUGIN_HANDLED;
		}

		td_turrets_set_player_totem(id, TOTEM_RANGE);
	}

	return PLUGIN_CONTINUE;
}
