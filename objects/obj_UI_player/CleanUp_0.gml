// CLEAN UP — executado quando a instância é removida, inclusive na troca de sala.
// Usa o fechamento normal para liberar global.player_in_menu e restaurar o player
// se ele ainda existir. Assim, a câmera não fica presa no zoom de menu.
// Uma instância duplicada pode ser destruída no Create antes de definir menu_set_open;
// variable_instance_exists evita chamar um método que ainda não foi criado.
if (variable_instance_exists(id, "menu_set_open")) menu_set_open(false);
