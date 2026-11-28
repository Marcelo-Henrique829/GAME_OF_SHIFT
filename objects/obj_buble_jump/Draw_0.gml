var _atualizar = true;
for (var _vista = 0; view_enabled && _vista < view_current; ++_vista)
{
    if (!view_visible[_vista]) continue;
    _atualizar = false;
    break;
}

scr_boing_draw(boing_pendente, _atualizar);
if (_atualizar) boing_pendente = false;
