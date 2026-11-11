# GAME_OF_SHIFT
rojeto em desenvolvimento para submissão à Game Off 2026 Game Jam. Desenvolvido com o objetivo de participar do evento e explorar novas ideias e mecânicas de gameplay.

## Criando atalhos de menu

`obj_shortcut` concentra o desenho, o destaque do mouse e o clique com transição
de sala. `obj_plataformer_shotcut` é um exemplo de filho.

Para criar outro atalho:

1. Crie um objeto com `obj_shortcut` como pai e escolha o sprite no editor.
2. Adicione somente o evento Create com as configurações do novo atalho:

```gml
event_inherited();
text = "Top Down";
target_room = Rm_TopDownTest;
```

Após `event_inherited()`, também é possível ajustar `text_gap`, `text_font`,
`text_color`, `hover_enabled`, `hover_color`, `hover_alpha` e `hover_padding`.
Os eventos Draw e End Step são herdados; não é necessário copiá-los.
Coloque o filho na sala do menu. O cursor reconhece todos os filhos automaticamente.
Sem uma sala de destino válida, o clique não inicia a transição.

## License

The source code is licensed under the MIT License.

All original game assets, including sprites, artwork, music and sound effects, are proprietary and may not be used commercially without prior written permission from the author.

Third-party assets remain the property of their respective owners.
