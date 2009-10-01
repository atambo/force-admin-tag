#include <amxmodx>
#include <amxmisc>
public plugin_init()
{
	register_plugin("Admin Tag Enforcement/Protection", "1", "atambo")
	register_cvar("amx_taginfront", "1")
	register_cvar("amx_tagprotect", "1")
	register_cvar("amx_clantag", "none")
}
public client_putinserver(id)
    set_task(1.5,"admin_entered",id) 
public admin_entered(id)
{
    new name[32]
    get_user_name(id, name, 31)
	return force_tag(id, name)
}
force_tag(id, name[])
{
	new clantag[24]
	get_cvar_string("amx_clantag",clantag,23)
	if(get_cvar_num("amx_tagprotect") == 0)
		return PLUGIN_CONTINUE
	if(get_cvar_num("amx_taginfront") == 1)
	{
		if(is_user_admin(id) && (containi(name, clantag)<0) && (!access(id, ADMIN_IMMUNITY)))
		{
        		copy(name,23,name)
            	client_cmd(id,"name ^"%s%s^"",clantag,name)
        }
        if((!is_user_admin(id)) && (containi(name, clantag)>=0))
		{
            deletei(name, clantag)
            trim(name)
            if(strlen(name) == 0) 
               	copy(name, 7, "Player")
           	client_cmd(id, "name ^"%s^"", name)
        }
    	return PLUGIN_CONTINUE
	}
	else
	{
		if(is_user_admin(id) && (containi(name, clantag)<0) && (!access(id, ADMIN_IMMUNITY)))
		{
        	copy(name,23,name)
            client_cmd(id,"name ^"%s%s^"",name,clantag)
        }
        if((!is_user_admin(id)) && (containi(name, clantag)>=0))
		{
            deletei(name, clantag)
            trim(name)
            if(strlen(name) == 0) 
               	copy(name, 7, "Player")
           	client_cmd(id, "name ^"%s^"", name)
       	}
    	return PLUGIN_CONTINUE
	}
	return PLUGIN_CONTINUE
}
public client_infochanged(id)
{
    new name[32]
    get_user_info(id, "name", name, 31)
	return force_tag(id, name)
}
deletei(text[], const what[])
{
    new pos
    new len
    new i
    pos = containi(text, what)
    while (pos>=0) 
	{
      	len = strlen(what)
        i = 0
        while (text[pos+len+i]!=0) 
		{
            text[pos+i] = text[pos+len+i]
           	i++
        }
        text[pos+i] = 0
        pos = containi(text, what)
    }
} 